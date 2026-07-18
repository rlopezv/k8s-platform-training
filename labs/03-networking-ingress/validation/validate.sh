#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
INGRESS="${INGRESS:-platform-api}"
INGRESS_HOST="${INGRESS_HOST:-platform-api.local}"
INGRESS_CLASS="${INGRESS_CLASS:-public}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local}"
SERVICE_DNS="${SERVICE_DNS:-platform-api.platform-training.svc.cluster.local}"
INGRESS_URL="${INGRESS_URL:-http://127.0.0.1/}"
TMP_OUT="/tmp/unit03-kubectl.out"
TMP_ERR="/tmp/unit03-kubectl.err"

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

echo "Unit 03 networking and ingress validation"
echo "This validation checks the expected Deployment, Service, EndpointSlice, DNS, Ingress Controller and Ingress route."
echo "It creates a temporary diagnostic Pod for DNS resolution and removes it automatically."
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
  echo "kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT"
  if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=120s; then
    check PASS "deployment rollout" "$DEPLOYMENT is available"
  else
    check FAIL "deployment rollout" "$DEPLOYMENT did not complete"
  fi
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

  service_type="$(jsonpath service "$SERVICE" '{.spec.type}')"
  if [ "$service_type" = "ClusterIP" ]; then
    check PASS "service type" "$SERVICE remains ClusterIP"
  else
    check FAIL "service type" "$SERVICE type is '$service_type', expected ClusterIP"
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
  echo "DNS check for $SERVICE_DNS from a temporary Pod"
  if kubectl -n "$NAMESPACE" run unit03-dns-check --rm -i --restart=Never --image=busybox:1.36 -- nslookup "$SERVICE_DNS"; then
    check PASS "cluster dns" "$SERVICE_DNS resolves from inside the cluster"
  else
    check FAIL "cluster dns" "$SERVICE_DNS did not resolve from the diagnostic Pod"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl get ingressclass $INGRESS_CLASS"
  if kubectl_get get ingressclass "$INGRESS_CLASS"; then
    cat "$TMP_OUT"
    check PASS "ingress class" "$INGRESS_CLASS exists"
  else
    cat "$TMP_ERR"
    check FAIL "ingress class" "$INGRESS_CLASS does not exist; verify the MicroK8s ingress addon"
  fi
fi

if [ "$failures" -eq 0 ]; then
  ready_ingress_pods="$(kubectl get pods -n ingress --no-headers 2>/dev/null | awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) count++ } END { print count + 0 }')"
  if [ "${ready_ingress_pods:-0}" -gt 0 ]; then
    check PASS "ingress controller" "$ready_ingress_pods pod(s) in namespace ingress report Ready containers"
  else
    check FAIL "ingress controller" "no Ready controller Pods found in namespace ingress"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get ingress $INGRESS"
  if kubectl_get -n "$NAMESPACE" get ingress "$INGRESS"; then
    cat "$TMP_OUT"
    check PASS "ingress" "$INGRESS exists"
  else
    cat "$TMP_ERR"
    check FAIL "ingress" "$INGRESS does not exist"
  fi

  ingress_host="$(jsonpath ingress "$INGRESS" '{.spec.rules[0].host}')"
  ingress_service="$(jsonpath ingress "$INGRESS" '{.spec.rules[0].http.paths[0].backend.service.name}')"
  ingress_port="$(jsonpath ingress "$INGRESS" '{.spec.rules[0].http.paths[0].backend.service.port.number}')"

  if [ "$ingress_host" = "$INGRESS_HOST" ]; then
    check PASS "ingress host" "$INGRESS_HOST is configured"
  else
    check FAIL "ingress host" "found '$ingress_host', expected '$INGRESS_HOST'"
  fi

  if [ "$ingress_service" = "$SERVICE" ] && [ "$ingress_port" = "80" ]; then
    check PASS "ingress backend" "$INGRESS routes to service/$SERVICE port 80"
  else
    check FAIL "ingress backend" "found service '$ingress_service' port '$ingress_port'"
  fi
fi

if [ "$failures" -eq 0 ]; then
  if command_exists curl; then
    echo
    echo "curl -i -H Host:$INGRESS_HOST $INGRESS_URL"
    http_response="$(curl -isS --max-time 10 -H "Host: $INGRESS_HOST" "$INGRESS_URL" 2>"$TMP_ERR")"
    curl_status=$?
    if [ "$curl_status" -eq 0 ] && contains "$http_response" "HTTP/" && contains "$http_response" "200"; then
      printf '%s\n' "$http_response" | sed -n '1,12p'
      check PASS "ingress http" "$INGRESS_URL responds with HTTP 200 for host $INGRESS_HOST"
    else
      cat "$TMP_ERR"
      printf '%s\n' "$http_response" | sed -n '1,12p'
      check FAIL "ingress http" "$INGRESS_URL did not return HTTP 200 for host $INGRESS_HOST"
    fi
  else
    check WARN "curl" "command not found; HTTP ingress check skipped"
  fi
fi

rm -f "$TMP_OUT" "$TMP_ERR"

echo
echo "Unit 03 validation summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
