#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
INGRESS="${INGRESS:-platform-api}"
PDB="${PDB:-platform-api}"
PVC="${PVC:-platform-api-data}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local}"
INGRESS_HOST="${INGRESS_HOST:-platform-api.local}"
INGRESS_URL="${INGRESS_URL:-http://127.0.0.1/}"
EXPECTED_TEXT="${EXPECTED_TEXT:-Unidad 05}"
TMP_OUT="/tmp/unit05-kubectl.out"
TMP_ERR="/tmp/unit05-kubectl.err"

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

jsonpath_ns() {
  kubectl -n "$NAMESPACE" get "$1" "$2" -o "jsonpath=$3" 2>/dev/null
}

ready_pod_count() {
  kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null |
    awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) count++ } END { print count + 0 }'
}

first_ready_pod() {
  kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null |
    awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) { print $1; exit } }'
}

echo "Unit 05 scheduling, resilience and maintenance validation"
echo "This validation checks Deployment rollout, safe scheduling constraints, PDB, Service, EndpointSlice, Ingress, PVC and controlled Pod recovery."
echo "It deletes one application Pod so the Deployment recreates it. It does not drain nodes, modify taints, delete PVCs or reset MicroK8s."
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
  echo "kubectl get nodes --show-labels"
  if kubectl get nodes --show-labels; then
    ready_nodes="$(kubectl get nodes --no-headers 2>/dev/null | awk '$2 == "Ready" { count++ } END { print count + 0 }')"
    if [ "${ready_nodes:-0}" -gt 0 ]; then
      check PASS "cluster nodes" "$ready_nodes Ready node(s) found"
    else
      check FAIL "cluster nodes" "no Ready nodes found"
    fi
  else
    check FAIL "cluster nodes" "node query failed"
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
  replicas="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.replicas}')"
  strategy="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.strategy.type}')"
  max_unavailable="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.strategy.rollingUpdate.maxUnavailable}')"
  max_surge="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.strategy.rollingUpdate.maxSurge}')"
  node_selector="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.template.spec.nodeSelector.kubernetes\.io/os}')"
  anti_affinity="$(jsonpath_ns deployment "$DEPLOYMENT" '{.spec.template.spec.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight}')"

  [ "$replicas" = "2" ] && check PASS "deployment replicas" "$DEPLOYMENT declares 2 replicas" || check FAIL "deployment replicas" "$DEPLOYMENT declares '$replicas', expected 2"
  [ "$strategy" = "RollingUpdate" ] && check PASS "deployment strategy" "RollingUpdate is explicit" || check FAIL "deployment strategy" "strategy is '$strategy', expected RollingUpdate"
  [ "$max_unavailable" = "1" ] && check PASS "rolling maxUnavailable" "maxUnavailable is 1" || check FAIL "rolling maxUnavailable" "value is '$max_unavailable', expected 1"
  [ "$max_surge" = "1" ] && check PASS "rolling maxSurge" "maxSurge is 1" || check FAIL "rolling maxSurge" "value is '$max_surge', expected 1"
  [ "$node_selector" = "linux" ] && check PASS "nodeSelector" "kubernetes.io/os=linux" || check FAIL "nodeSelector" "value is '$node_selector', expected linux"
  [ -n "$anti_affinity" ] && check PASS "pod anti-affinity" "preferred anti-affinity is declared" || check FAIL "pod anti-affinity" "preferred anti-affinity is missing"
fi

if [ "$failures" -eq 0 ]; then
  ready_pods="$(ready_pod_count)"
  if [ "${ready_pods:-0}" -ge 1 ]; then
    check PASS "ready pods" "$ready_pods Ready pod(s) found for selector $SELECTOR"
  else
    check FAIL "ready pods" "no Ready pods found for selector $SELECTOR"
  fi

  unassigned_pods="$(kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" -o jsonpath='{range .items[?(@.spec.nodeName=="")]}{.metadata.name}{"\n"}{end}' 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${unassigned_pods:-0}" -eq 0 ]; then
    check PASS "pod scheduling" "all selected Pods are assigned to a node"
  else
    check FAIL "pod scheduling" "$unassigned_pods Pod(s) are not assigned to a node"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get pdb $PDB"
  if kubectl_get -n "$NAMESPACE" get pdb "$PDB"; then
    cat "$TMP_OUT"
    check PASS "pdb" "$PDB exists"
  else
    cat "$TMP_ERR"
    check FAIL "pdb" "$PDB does not exist"
  fi

  min_available="$(jsonpath_ns pdb "$PDB" '{.spec.minAvailable}')"
  disruptions_allowed="$(jsonpath_ns pdb "$PDB" '{.status.disruptionsAllowed}')"
  [ "$min_available" = "1" ] && check PASS "pdb minAvailable" "minAvailable is 1" || check FAIL "pdb minAvailable" "value is '$min_available', expected 1"
  if [ -n "$disruptions_allowed" ]; then
    check PASS "pdb status" "disruptionsAllowed is $disruptions_allowed"
  else
    check WARN "pdb status" "disruptionsAllowed not reported yet"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get pvc $PVC"
  if kubectl_get -n "$NAMESPACE" get pvc "$PVC"; then
    cat "$TMP_OUT"
    check PASS "pvc" "$PVC exists"
  else
    cat "$TMP_ERR"
    check FAIL "pvc" "$PVC does not exist"
  fi

  pvc_phase="$(jsonpath_ns pvc "$PVC" '{.status.phase}')"
  [ "$pvc_phase" = "Bound" ] && check PASS "pvc phase" "$PVC is Bound" || check FAIL "pvc phase" "$PVC is '$pvc_phase', expected Bound"
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
  echo
  echo "kubectl -n $NAMESPACE get ingress $INGRESS"
  if kubectl_get -n "$NAMESPACE" get ingress "$INGRESS"; then
    cat "$TMP_OUT"
    check PASS "ingress" "$INGRESS exists"
  else
    cat "$TMP_ERR"
    check FAIL "ingress" "$INGRESS does not exist"
  fi
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

pod=""
if [ "$failures" -eq 0 ]; then
  pod="$(first_ready_pod)"
  if [ -n "$pod" ]; then
    echo
    echo "kubectl -n $NAMESPACE delete pod $pod"
    if kubectl -n "$NAMESPACE" delete pod "$pod" --wait=true; then
      check PASS "pod recreation trigger" "$pod deleted; Deployment should recover desired state"
    else
      check FAIL "pod recreation trigger" "could not delete $pod"
    fi

    if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=180s; then
      check PASS "deployment after recreation" "$DEPLOYMENT is available after Pod deletion"
    else
      check FAIL "deployment after recreation" "$DEPLOYMENT did not recover after Pod deletion"
    fi
  else
    check FAIL "pod recreation trigger" "no Ready pod available for controlled deletion"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE rollout history deployment/$DEPLOYMENT"
  if kubectl -n "$NAMESPACE" rollout history "deployment/$DEPLOYMENT"; then
    check PASS "rollout history" "history is readable"
  else
    check WARN "rollout history" "history command failed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "Recent scheduling events"
  kubectl -n "$NAMESPACE" get events --sort-by=.lastTimestamp 2>/dev/null | tail -n 20 || true
fi

rm -f "$TMP_OUT" "$TMP_ERR"

echo
echo "Unit 05 validation summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi
