#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
CONFIGMAP="${CONFIGMAP:-platform-api-config}"
SECRET="${SECRET:-platform-api-secret}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local}"
TMP_OUT="/tmp/unit02-kubectl.out"
TMP_ERR="/tmp/unit02-kubectl.err"

failures=0
warnings=0

check() {
  local status="$1"
  local name="$2"
  local detail="$3"

  printf '[%s] %s - %s\n' "$status" "$name" "$detail"
  case "$status" in
    FAIL) failures=$((failures + 1)) ;;
    WARN) warnings=$((warnings + 1)) ;;
  esac
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

kubectl_get() {
  kubectl "$@" >"$TMP_OUT" 2>"$TMP_ERR"
}

jsonpath() {
  kubectl -n "$NAMESPACE" get "$1" "$2" -o "jsonpath=$3" 2>/dev/null
}

contains() {
  case "$1" in
    *"$2"*) return 0 ;;
    *) return 1 ;;
  esac
}

echo "Unit 02 configuration and lifecycle validation"
echo "This script is read-only and validates the expected ConfigMap, Secret, Deployment, probes, resources and Service."
echo

if ! command_exists kubectl; then
  check FAIL "kubectl" "command not found"
else
  check PASS "kubectl" "available at $(command -v kubectl)"
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl config current-context"
  if kubectl config current-context; then
    check PASS "kubectl context" "current context is readable"
  else
    check WARN "kubectl context" "current context could not be read"
  fi

  echo
  echo "kubectl get nodes"
  if kubectl get nodes; then
    check PASS "cluster nodes" "node query completed"
  else
    check FAIL "cluster nodes" "node query failed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl get namespace $NAMESPACE"
  if kubectl_get get namespace "$NAMESPACE"; then
    cat "$TMP_OUT"
    check PASS "namespace" "$NAMESPACE exists"
  else
    cat "$TMP_ERR"
    check FAIL "namespace" "$NAMESPACE does not exist"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get configmap $CONFIGMAP"
  if kubectl_get -n "$NAMESPACE" get configmap "$CONFIGMAP"; then
    cat "$TMP_OUT"
    check PASS "configmap" "$CONFIGMAP exists"
  else
    cat "$TMP_ERR"
    check FAIL "configmap" "$CONFIGMAP does not exist"
  fi

  config_keys="$(jsonpath configmap "$CONFIGMAP" '{.data}')"
  for key in APP_ENV LOG_LEVEL FEATURE_GREETING index.html; do
    if contains "$config_keys" "$key"; then
      check PASS "configmap key" "$key is present"
    else
      check FAIL "configmap key" "$key is missing"
    fi
  done
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get secret $SECRET"
  if kubectl_get -n "$NAMESPACE" get secret "$SECRET"; then
    cat "$TMP_OUT"
    check PASS "secret" "$SECRET exists"
  else
    cat "$TMP_ERR"
    check FAIL "secret" "$SECRET does not exist"
  fi

  secret_keys="$(jsonpath secret "$SECRET" '{.data}')"
  for key in LAB_CLIENT_ID LAB_API_TOKEN; do
    if contains "$secret_keys" "$key"; then
      check PASS "secret key" "$key is present without printing its value"
    else
      check FAIL "secret key" "$key is missing"
    fi
  done
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT"
  if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=120s; then
    check PASS "deployment rollout" "$DEPLOYMENT is available"
  else
    check FAIL "deployment rollout" "$DEPLOYMENT did not complete"
  fi
fi

if [ "$failures" -eq 0 ]; then
  deploy_yaml="$(kubectl -n "$NAMESPACE" get deployment "$DEPLOYMENT" -o yaml 2>/dev/null)"

  for expected in "configMapKeyRef:" "secretKeyRef:" "startupProbe:" "readinessProbe:" "livenessProbe:" "requests:" "limits:" "platform-api-content"; do
    if contains "$deploy_yaml" "$expected"; then
      check PASS "deployment spec" "$expected is present"
    else
      check FAIL "deployment spec" "$expected is missing"
    fi
  done
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get rs,pods -l $SELECTOR"
  if kubectl -n "$NAMESPACE" get rs,pods -l "$SELECTOR"; then
    check PASS "replicaset and pods" "resources selected by expected labels"
  else
    check FAIL "replicaset and pods" "resources were not selected"
  fi
fi

if [ "$failures" -eq 0 ]; then
  ready_pods="$(kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null | awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) count++ } END { print count + 0 }')"
  if [ "${ready_pods:-0}" -gt 0 ]; then
    check PASS "ready pods" "$ready_pods pod(s) report Ready containers"
  else
    check FAIL "ready pods" "no Ready pods found for selector $SELECTOR"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get service $SERVICE"
  if kubectl_get -n "$NAMESPACE" get service "$SERVICE"; then
    cat "$TMP_OUT"
    check PASS "service" "$SERVICE exists"
  else
    cat "$TMP_ERR"
    check FAIL "service" "$SERVICE does not exist"
  fi
fi

if [ "$failures" -eq 0 ]; then
  endpoint_count="$(kubectl -n "$NAMESPACE" get endpointslice -l "kubernetes.io/service-name=$SERVICE" -o jsonpath='{.items[*].endpoints[*].addresses[*]}' 2>/dev/null | wc -w | tr -d ' ')"
  if [ "${endpoint_count:-0}" -gt 0 ]; then
    check PASS "service endpointslices" "$SERVICE has $endpoint_count endpoint address(es)"
  else
    legacy_endpoint_count="$(kubectl -n "$NAMESPACE" get endpoints "$SERVICE" -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w | tr -d ' ')"
    if [ "${legacy_endpoint_count:-0}" -gt 0 ]; then
      check WARN "service endpointslices" "EndpointSlice query returned none, but legacy Endpoints has $legacy_endpoint_count address(es)"
    else
      check FAIL "service endpoints" "$SERVICE has no endpoint addresses"
    fi
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE logs deployment/$DEPLOYMENT --tail=20"
  if kubectl -n "$NAMESPACE" logs "deployment/$DEPLOYMENT" --tail=20; then
    check PASS "logs" "deployment logs are readable"
  else
    check WARN "logs" "logs were not readable yet"
  fi
fi

rm -f "$TMP_OUT" "$TMP_ERR"

echo
echo "Unit 02 validation summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
