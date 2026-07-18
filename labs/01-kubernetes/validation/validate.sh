#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
SELECTOR="${SELECTOR:-app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local}"

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
  kubectl "$@" >/tmp/unit01-kubectl.out 2>/tmp/unit01-kubectl.err
}

echo "Unit 01 Kubernetes validation"
echo "This script is read-only and validates the expected namespace, Deployment, Pods and Service."
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
    cat /tmp/unit01-kubectl.out
    check PASS "namespace" "$NAMESPACE exists"
  else
    cat /tmp/unit01-kubectl.err
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
  ready_pods="$(kubectl -n "$NAMESPACE" get pods -l "$SELECTOR" --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l | tr -d ' ')"
  if [ "${ready_pods:-0}" -gt 0 ]; then
    check PASS "running pods" "$ready_pods pod(s) in Running phase"
  else
    check FAIL "running pods" "no Running pods found for selector $SELECTOR"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE get service $SERVICE"
  if kubectl_get -n "$NAMESPACE" get service "$SERVICE"; then
    cat /tmp/unit01-kubectl.out
    check PASS "service" "$SERVICE exists"
  else
    cat /tmp/unit01-kubectl.err
    check FAIL "service" "$SERVICE does not exist"
  fi
fi

if [ "$failures" -eq 0 ]; then
  endpoint_count="$(kubectl -n "$NAMESPACE" get endpoints "$SERVICE" -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null | wc -w | tr -d ' ')"
  if [ "${endpoint_count:-0}" -gt 0 ]; then
    check PASS "service endpoints" "$SERVICE has $endpoint_count endpoint address(es)"
  else
    check FAIL "service endpoints" "$SERVICE has no endpoint addresses"
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

rm -f /tmp/unit01-kubectl.out /tmp/unit01-kubectl.err

echo
echo "Unit 01 validation summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
