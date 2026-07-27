#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
STATEFULSET="${STATEFULSET:-scratch-stateful}"
SERVICE="${SERVICE:-scratch-stateful}"
STORAGE_CLASS="${STORAGE_CLASS:-microk8s-hostpath}"
REPLICAS="${REPLICAS:-2}"
MOUNT_PATH="${MOUNT_PATH:-/usr/share/nginx/html/stateful}"
DATA_FILE="${DATA_FILE:-identity.txt}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
TMP_OUT="/tmp/unit04-statefulset-demo.out"
TMP_ERR="/tmp/unit04-statefulset-demo.err"

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

cleanup() {
  echo "Cleaning Unit 04 StatefulSet demo resources"
  kubectl -n "$NAMESPACE" delete statefulset "$STATEFULSET" --ignore-not-found=true --wait=true
  kubectl -n "$NAMESPACE" delete service "$SERVICE" --ignore-not-found=true
  kubectl -n "$NAMESPACE" delete pvc "scratch-data-$STATEFULSET-0" "scratch-data-$STATEFULSET-1" --ignore-not-found=true
}

if [ "${1:-}" = "--cleanup" ]; then
  cleanup
  exit 0
fi

echo "Unit 04 StatefulSet demo validation"
echo "This validation deploys scratch-stateful, checks headless Service, stable Pod identities and one PVC per ordinal."
echo "It does not modify deployment/platform-api or persistentvolumeclaim/platform-api-data."
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
  echo "kubectl get storageclass $STORAGE_CLASS"
  if kubectl_get get storageclass "$STORAGE_CLASS"; then
    cat "$TMP_OUT"
    check PASS "storageclass" "$STORAGE_CLASS exists"
  else
    cat "$TMP_ERR"
    check FAIL "storageclass" "$STORAGE_CLASS does not exist"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl apply -f labs/04-persistence-state/solution/namespace.yaml"
  if kubectl apply -f "$REPO_ROOT/labs/04-persistence-state/solution/namespace.yaml"; then
    check PASS "namespace apply" "$NAMESPACE declared"
  else
    check FAIL "namespace apply" "could not apply namespace manifest"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl apply -f labs/04-persistence-state/statefulset-demo/service.yaml"
  if kubectl apply -f "$SCRIPT_DIR/service.yaml"; then
    check PASS "headless service apply" "$SERVICE applied"
  else
    check FAIL "headless service apply" "could not apply service manifest"
  fi

  echo
  echo "kubectl apply -f labs/04-persistence-state/statefulset-demo/statefulset.yaml"
  if kubectl apply -f "$SCRIPT_DIR/statefulset.yaml"; then
    check PASS "statefulset apply" "$STATEFULSET applied"
  else
    check FAIL "statefulset apply" "could not apply statefulset manifest"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE rollout status statefulset/$STATEFULSET"
  if kubectl -n "$NAMESPACE" rollout status "statefulset/$STATEFULSET" --timeout=240s; then
    check PASS "statefulset rollout" "$STATEFULSET is ready"
  else
    check FAIL "statefulset rollout" "$STATEFULSET did not become ready"
  fi
fi

if [ "$failures" -eq 0 ]; then
  service_cluster_ip="$(jsonpath service "$SERVICE" '{.spec.clusterIP}')"
  if [ "$service_cluster_ip" = "None" ]; then
    check PASS "headless service" "$SERVICE has clusterIP None"
  else
    check FAIL "headless service" "$SERVICE clusterIP is '$service_cluster_ip', expected None"
  fi

  service_name="$(jsonpath statefulset "$STATEFULSET" '{.spec.serviceName}')"
  if [ "$service_name" = "$SERVICE" ]; then
    check PASS "statefulset serviceName" "$STATEFULSET uses $SERVICE"
  else
    check FAIL "statefulset serviceName" "$STATEFULSET uses '$service_name', expected $SERVICE"
  fi
fi

if [ "$failures" -eq 0 ]; then
  ready_replicas="$(jsonpath statefulset "$STATEFULSET" '{.status.readyReplicas}')"
  if [ "${ready_replicas:-0}" = "$REPLICAS" ]; then
    check PASS "ready replicas" "$ready_replicas/$REPLICAS replicas are ready"
  else
    check FAIL "ready replicas" "${ready_replicas:-0}/$REPLICAS replicas are ready"
  fi
fi

ordinal=0
while [ "$ordinal" -lt "$REPLICAS" ] && [ "$failures" -eq 0 ]; do
  pod="$STATEFULSET-$ordinal"
  claim="scratch-data-$pod"

  echo
  echo "kubectl -n $NAMESPACE get pod $pod"
  if kubectl_get -n "$NAMESPACE" get pod "$pod"; then
    cat "$TMP_OUT"
    check PASS "pod $pod" "$pod exists"
  else
    cat "$TMP_ERR"
    check FAIL "pod $pod" "$pod does not exist"
  fi

  echo
  echo "kubectl -n $NAMESPACE get pvc $claim"
  if kubectl_get -n "$NAMESPACE" get pvc "$claim"; then
    cat "$TMP_OUT"
    check PASS "pvc $claim" "$claim exists"
  else
    cat "$TMP_ERR"
    check FAIL "pvc $claim" "$claim does not exist"
  fi

  pvc_phase="$(jsonpath pvc "$claim" '{.status.phase}')"
  if [ "$pvc_phase" = "Bound" ]; then
    check PASS "pvc phase $claim" "$claim is Bound"
  else
    check FAIL "pvc phase $claim" "$claim is '$pvc_phase', expected Bound"
  fi

  pvc_class="$(jsonpath pvc "$claim" '{.spec.storageClassName}')"
  if [ "$pvc_class" = "$STORAGE_CLASS" ]; then
    check PASS "pvc storageclass $claim" "$claim uses $STORAGE_CLASS"
  else
    check FAIL "pvc storageclass $claim" "$claim uses '$pvc_class', expected $STORAGE_CLASS"
  fi

  if kubectl -n "$NAMESPACE" exec "$pod" -- sh -c "grep -F 'pod=$pod' '$MOUNT_PATH/$DATA_FILE' && grep -F 'claim=$claim' '$MOUNT_PATH/$DATA_FILE'"; then
    check PASS "identity file $pod" "$pod writes its own ordinal and claim"
  else
    check FAIL "identity file $pod" "$pod did not expose expected identity data"
  fi

  ordinal=$((ordinal + 1))
done

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get pvc platform-api-data"
  if kubectl_get -n "$NAMESPACE" get pvc platform-api-data; then
    cat "$TMP_OUT"
    check PASS "platform-api pvc preserved" "platform-api-data still exists and was not targeted by this validation"
  else
    cat "$TMP_ERR"
    check WARN "platform-api pvc preserved" "platform-api-data not found; demo validation did not delete it"
  fi
fi

if [ "$failures" -eq 0 ]; then
  dns_pod="scratch-dns-check"
  echo
  echo "Checking DNS names through headless Service"
  kubectl -n "$NAMESPACE" delete pod "$dns_pod" --ignore-not-found=true --wait=true >/dev/null 2>&1
  if kubectl -n "$NAMESPACE" run "$dns_pod" --image=busybox:1.37.0 --restart=Never --rm -i --command -- sh -c "nslookup $STATEFULSET-0.$SERVICE.$NAMESPACE.svc.cluster.local && nslookup $STATEFULSET-1.$SERVICE.$NAMESPACE.svc.cluster.local"; then
    check PASS "headless dns" "ordinal DNS names resolve"
  else
    check FAIL "headless dns" "ordinal DNS names did not resolve"
  fi
  kubectl -n "$NAMESPACE" delete pod "$dns_pod" --ignore-not-found=true --wait=true >/dev/null 2>&1
fi

echo
echo "Unit 04 StatefulSet demo validation summary: $failures failure(s), $warnings warning(s)."

rm -f "$TMP_OUT" "$TMP_ERR"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
