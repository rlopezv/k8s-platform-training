#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
INGRESS="${INGRESS:-platform-api}"
PVC="${PVC:-platform-api-data}"
STORAGE_CLASS="${STORAGE_CLASS:-microk8s-hostpath}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local}"
MOUNT_PATH="${MOUNT_PATH:-/usr/share/nginx/html/persistent}"
DATA_FILE="${DATA_FILE:-message.txt}"
INGRESS_HOST="${INGRESS_HOST:-platform-api.local}"
INGRESS_URL="${INGRESS_URL:-http://127.0.0.1/}"
EXPECTED_TEXT="${EXPECTED_TEXT:-Unidad 04 persistent data}"
TMP_OUT="/tmp/unit04-kubectl.out"
TMP_ERR="/tmp/unit04-kubectl.err"

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

first_ready_pod() {
  kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null |
    awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) { print $1; exit } }'
}

echo "Unit 04 persistence and state validation"
echo "This validation checks Deployment, Service, Ingress, StorageClass, PVC, mount, write/read and persistence after Pod recreation."
echo "It writes a non-sensitive lab file to the persistent volume and deletes one application Pod so the Deployment recreates it."
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
    check FAIL "storageclass" "$STORAGE_CLASS does not exist; enable MicroK8s hostpath storage for this local lab"
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
  echo "kubectl -n $NAMESPACE get pvc $PVC"
  if kubectl_get -n "$NAMESPACE" get pvc "$PVC"; then
    cat "$TMP_OUT"
    check PASS "pvc" "$PVC exists"
  else
    cat "$TMP_ERR"
    check FAIL "pvc" "$PVC does not exist"
  fi

  pvc_phase="$(jsonpath pvc "$PVC" '{.status.phase}')"
  if [ "$pvc_phase" = "Bound" ]; then
    check PASS "pvc phase" "$PVC is Bound"
  else
    check FAIL "pvc phase" "$PVC is '$pvc_phase', expected Bound"
  fi

  pvc_class="$(jsonpath pvc "$PVC" '{.spec.storageClassName}')"
  if [ "$pvc_class" = "$STORAGE_CLASS" ]; then
    check PASS "pvc storageclass" "$PVC uses $STORAGE_CLASS"
  else
    check FAIL "pvc storageclass" "$PVC uses '$pvc_class', expected $STORAGE_CLASS"
  fi

  volume_name="$(jsonpath pvc "$PVC" '{.spec.volumeName}')"
  if [ -n "$volume_name" ]; then
    check PASS "persistent volume" "$PVC is bound to $volume_name"
  else
    check FAIL "persistent volume" "$PVC has no associated PV name"
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
  ready_pods="$(kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --no-headers 2>/dev/null | awk '$2 ~ /^[0-9]+\/[0-9]+$/ { split($2, a, "/"); if (a[1] == a[2]) count++ } END { print count + 0 }')"
  if [ "${ready_pods:-0}" -gt 0 ]; then
    check PASS "ready pods" "$ready_pods pod(s) report Ready containers"
  else
    check FAIL "ready pods" "no Ready pods found for selector $SELECTOR"
  fi
fi

pod=""
if [ "$failures" -eq 0 ]; then
  pod="$(first_ready_pod)"
  if [ -n "$pod" ]; then
    check PASS "diagnostic pod" "using $pod"
  else
    check FAIL "diagnostic pod" "no Ready pod available for exec checks"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE exec $pod -- sh -c 'test -d $MOUNT_PATH && test -w $MOUNT_PATH'"
  if kubectl -n "$NAMESPACE" exec "$pod" -- sh -c "test -d '$MOUNT_PATH' && test -w '$MOUNT_PATH'"; then
    check PASS "volume mount" "$MOUNT_PATH exists and is writable"
  else
    check FAIL "volume mount" "$MOUNT_PATH is missing or not writable"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "Writing non-sensitive lab data to $MOUNT_PATH/$DATA_FILE"
  if kubectl -n "$NAMESPACE" exec "$pod" -- sh -c "printf '%s\n' '$EXPECTED_TEXT' > '$MOUNT_PATH/$DATA_FILE' && sync"; then
    check PASS "write data" "wrote $DATA_FILE in persistent mount"
  else
    check FAIL "write data" "could not write $DATA_FILE in persistent mount"
  fi
fi

if [ "$failures" -eq 0 ]; then
  if kubectl -n "$NAMESPACE" exec "$pod" -- sh -c "grep -F '$EXPECTED_TEXT' '$MOUNT_PATH/$DATA_FILE'"; then
    check PASS "read data" "read expected content before Pod recreation"
  else
    check FAIL "read data" "expected content not found before Pod recreation"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE delete pod $pod"
  if kubectl -n "$NAMESPACE" delete pod "$pod" --wait=true; then
    check PASS "pod recreation trigger" "$pod deleted; Deployment should recreate capacity"
  else
    check FAIL "pod recreation trigger" "could not delete $pod"
  fi

  if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=180s; then
    check PASS "deployment after recreation" "$DEPLOYMENT is available after Pod deletion"
  else
    check FAIL "deployment after recreation" "$DEPLOYMENT did not recover after Pod deletion"
  fi
fi

if [ "$failures" -eq 0 ]; then
  new_pod="$(first_ready_pod)"
  if [ -n "$new_pod" ]; then
    echo
    echo "Reading persistent data from $new_pod"
    if kubectl -n "$NAMESPACE" exec "$new_pod" -- sh -c "grep -F '$EXPECTED_TEXT' '$MOUNT_PATH/$DATA_FILE'"; then
      check PASS "persistence after recreation" "expected content survived Pod recreation"
    else
      check FAIL "persistence after recreation" "expected content was not found after Pod recreation"
    fi
  else
    check FAIL "persistence after recreation" "no Ready pod available after recreation"
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
  echo "curl -i -H Host:$INGRESS_HOST ${INGRESS_URL%/}/persistent/$DATA_FILE"
  if curl -sS -i -H "Host: $INGRESS_HOST" "${INGRESS_URL%/}/persistent/$DATA_FILE" | tee "$TMP_OUT" | grep -q "$EXPECTED_TEXT"; then
    check PASS "ingress persistent http" "persistent file is served through Ingress"
  else
    cat "$TMP_OUT"
    check FAIL "ingress persistent http" "persistent file was not served through Ingress"
  fi
elif [ "$failures" -eq 0 ]; then
  check WARN "curl" "curl not available; skipped HTTP check for persistent file"
fi

echo
echo "Unit 04 validation summary: $failures failure(s), $warnings warning(s)."

rm -f "$TMP_OUT" "$TMP_ERR"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
