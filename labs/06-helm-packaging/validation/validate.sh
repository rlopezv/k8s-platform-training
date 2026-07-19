#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
RELEASE="${RELEASE:-platform-api-local}"
CHART_DIR="${CHART_DIR:-labs/06-helm-packaging/chart/platform-api}"
VALUES_FILE="${VALUES_FILE:-$CHART_DIR/values-local.yaml}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
INGRESS="${INGRESS:-platform-api}"
PDB="${PDB:-platform-api}"
PVC="${PVC:-platform-api-data}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=$RELEASE}"
INGRESS_HOST="${INGRESS_HOST:-platform-api.local}"
INGRESS_URL="${INGRESS_URL:-http://127.0.0.1/}"
EXPECTED_TEXT="${EXPECTED_TEXT:-Unidad 06}"
TMP_RENDER="/tmp/unit06-helm-rendered.yaml"
TMP_OUT="/tmp/unit06-kubectl.out"
TMP_ERR="/tmp/unit06-kubectl.err"

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

jsonpath_ns() {
  kubectl -n "$NAMESPACE" get "$1" "$2" -o "jsonpath=$3" 2>/dev/null
}

ready_pod_count() {
  kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null |
    awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) count++ } END { print count + 0 }'
}

kubectl_get() {
  kubectl "$@" >"$TMP_OUT" 2>"$TMP_ERR"
}

echo "Unit 06 Helm packaging validation"
echo "This validation checks chart rendering, Helm release state, Deployment rollout, Service, EndpointSlice, Ingress, PVC, PDB and lab-only Secret values."
echo "It does not uninstall the release, delete PVCs, publish charts, run Terraform or reset MicroK8s."
echo

for cmd in helm kubectl; do
  if command_exists "$cmd"; then
    check PASS "$cmd" "available at $(command -v "$cmd")"
  else
    check FAIL "$cmd" "command not found"
  fi
done

if [ "$failures" -eq 0 ]; then
  echo
  echo "helm lint $CHART_DIR"
  if helm lint "$CHART_DIR"; then
    check PASS "helm lint" "chart syntax and metadata accepted"
  else
    check FAIL "helm lint" "chart lint failed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "helm template $RELEASE $CHART_DIR --namespace $NAMESPACE -f $VALUES_FILE"
  if helm template "$RELEASE" "$CHART_DIR" --namespace "$NAMESPACE" -f "$VALUES_FILE" >"$TMP_RENDER"; then
    check PASS "helm template" "rendered manifests written to $TMP_RENDER"
  else
    check FAIL "helm template" "render failed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl apply --dry-run=client -f $TMP_RENDER"
  if kubectl apply --dry-run=client -f "$TMP_RENDER"; then
    check PASS "kubectl dry-run" "rendered manifests accepted by client dry-run"
  else
    check FAIL "kubectl dry-run" "rendered manifests rejected"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "helm status $RELEASE --namespace $NAMESPACE"
  if helm status "$RELEASE" --namespace "$NAMESPACE"; then
    check PASS "helm release" "$RELEASE exists in $NAMESPACE"
  else
    check FAIL "helm release" "$RELEASE is not installed; run helm upgrade --install first"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT"
  if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=180s; then
    check PASS "deployment rollout" "$DEPLOYMENT is available"
  else
    check FAIL "deployment rollout" "$DEPLOYMENT did not complete"
  fi
fi

if [ "$failures" -eq 0 ]; then
  managed_by="$(jsonpath_ns deployment "$DEPLOYMENT" '{.metadata.labels.app\.kubernetes\.io/managed-by}')"
  replicas="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.replicas}')"
  unit="$(jsonpath_ns deployment "$DEPLOYMENT" '{.metadata.labels.training\.k8s-platform\.io/unit}')"
  node_selector="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.template.spec.nodeSelector.kubernetes\.io/os}')"

  [ "$managed_by" = "Helm" ] && check PASS "managed-by label" "Deployment is managed by Helm" || check FAIL "managed-by label" "value is '$managed_by', expected Helm"
  [ "$replicas" = "2" ] && check PASS "deployment replicas" "$DEPLOYMENT declares 2 replicas" || check FAIL "deployment replicas" "$DEPLOYMENT declares '$replicas', expected 2"
  [ "$unit" = "06" ] && check PASS "unit label" "training unit label is 06" || check FAIL "unit label" "value is '$unit', expected 06"
  [ "$node_selector" = "linux" ] && check PASS "nodeSelector" "kubernetes.io/os=linux" || check FAIL "nodeSelector" "value is '$node_selector', expected linux"
fi

if [ "$failures" -eq 0 ]; then
  ready_pods="$(ready_pod_count)"
  if [ "${ready_pods:-0}" -ge 1 ]; then
    check PASS "ready pods" "$ready_pods Ready pod(s) found for selector $SELECTOR"
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

  service_type="$(jsonpath_ns service "$SERVICE" '{.spec.type}')"
  [ "$service_type" = "ClusterIP" ] && check PASS "service type" "$SERVICE remains ClusterIP" || check FAIL "service type" "$SERVICE type is '$service_type', expected ClusterIP"
fi

if [ "$failures" -eq 0 ]; then
  endpoint_count="$(kubectl -n "$NAMESPACE" get endpointslice -l "kubernetes.io/service-name=$SERVICE" -o jsonpath='{.items[*].endpoints[*].addresses[*]}' 2>/dev/null | wc -w | tr -d ' ')"
  if [ "${endpoint_count:-0}" -gt 0 ]; then
    check PASS "service endpointslices" "$SERVICE has $endpoint_count endpoint address(es)"
  else
    check FAIL "service endpointslices" "$SERVICE has no endpoint addresses"
  fi
fi

if [ "$failures" -eq 0 ]; then
  for resource in "ingress/$INGRESS" "pvc/$PVC" "pdb/$PDB" "secret/platform-api-secret" "configmap/platform-api-config"; do
    if kubectl -n "$NAMESPACE" get "$resource" >/dev/null 2>&1; then
      check PASS "$resource" "exists"
    else
      check FAIL "$resource" "missing"
    fi
  done
fi

if [ "$failures" -eq 0 ]; then
  pvc_phase="$(jsonpath_ns pvc "$PVC" '{.status.phase}')"
  [ "$pvc_phase" = "Bound" ] && check PASS "pvc phase" "$PVC is Bound" || check FAIL "pvc phase" "$PVC is '$pvc_phase', expected Bound"
fi

if [ "$failures" -eq 0 ] && command_exists curl; then
  echo
  echo "curl -i -H Host:$INGRESS_HOST ${INGRESS_URL%/}/"
  if curl -sS -i -H "Host: $INGRESS_HOST" "${INGRESS_URL%/}/" | tee "$TMP_OUT" | grep -q "$EXPECTED_TEXT"; then
    check PASS "ingress http" "application response contains '$EXPECTED_TEXT'"
  else
    cat "$TMP_OUT"
    check FAIL "ingress http" "application response did not contain '$EXPECTED_TEXT'"
  fi
elif [ "$failures" -eq 0 ]; then
  check WARN "curl" "curl not available; skipped HTTP check"
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "helm history $RELEASE --namespace $NAMESPACE"
  if helm history "$RELEASE" --namespace "$NAMESPACE"; then
    check PASS "helm history" "release history is readable"
  else
    check WARN "helm history" "history command failed"
  fi
fi

if grep -R --line-number --ignore-case -E '(BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|password=|client_secret|api[_-]?key)' "$CHART_DIR" >/tmp/unit06-secret-scan.out 2>/dev/null; then
  cat /tmp/unit06-secret-scan.out
  check WARN "secret scan" "review findings above; lab placeholders are allowed, real secrets are not"
else
  check PASS "secret scan" "no obvious real credential patterns found in chart"
fi

rm -f "$TMP_RENDER" "$TMP_OUT" "$TMP_ERR" /tmp/unit06-secret-scan.out

echo
echo "Unit 06 validation summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi
