#!/usr/bin/env bash
set -u

NAMESPACE="${NAMESPACE:-platform-training}"
TEKTON_NAMESPACE="${TEKTON_NAMESPACE:-tekton-pipelines}"
PIPELINE_RUN="${PIPELINE_RUN:-platform-api-ci-run}"
TEKTON_VERSION="${TEKTON_VERSION:-v1.12.2}"
RUN_FUNCTIONAL="${RUN_FUNCTIONAL:-false}"
LAB_DIR="${LAB_DIR:-labs/08-tekton-continuous-integration}"
SOURCE_CONFIGMAP="${SOURCE_CONFIGMAP:-platform-api-ci-source}"

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

wait_for_pipelinerun() {
  local reason=""
  local status=""
  local i=0

  while [ "$i" -lt 60 ]; do
    status="$(kubectl -n "$NAMESPACE" get pipelinerun "$PIPELINE_RUN" -o jsonpath='{.status.conditions[0].status}' 2>/dev/null || true)"
    reason="$(kubectl -n "$NAMESPACE" get pipelinerun "$PIPELINE_RUN" -o jsonpath='{.status.conditions[0].reason}' 2>/dev/null || true)"
    if [ "$status" = "True" ]; then
      check PASS "pipelinerun" "$PIPELINE_RUN succeeded"
      return 0
    fi
    if [ "$status" = "False" ]; then
      kubectl -n "$NAMESPACE" describe pipelinerun "$PIPELINE_RUN" || true
      check FAIL "pipelinerun" "$PIPELINE_RUN failed with reason $reason"
      return 1
    fi
    sleep 5
    i=$((i + 1))
  done

  kubectl -n "$NAMESPACE" describe pipelinerun "$PIPELINE_RUN" || true
  check FAIL "pipelinerun" "$PIPELINE_RUN did not finish within timeout"
}

echo "Unit 08 Tekton CI validation"
echo "Static checks always run. Functional checks run only with RUN_FUNCTIONAL=true."
echo

for cmd in kubectl bash tar; do
  if command_exists "$cmd"; then
    check PASS "$cmd" "available at $(command -v "$cmd")"
  else
    check FAIL "$cmd" "command not found"
  fi
done

for file in \
  "$LAB_DIR/scripts/create-source-configmap.sh" \
  "$LAB_DIR/tekton/serviceaccount.yaml" \
  "$LAB_DIR/tekton/rbac.yaml" \
  "$LAB_DIR/tekton/tasks.yaml" \
  "$LAB_DIR/tekton/pipeline.yaml" \
  "$LAB_DIR/tekton/pipelinerun.yaml" \
  "$LAB_DIR/README.md"
do
  if [ -f "$file" ]; then
    check PASS "file" "$file exists"
  else
    check FAIL "file" "$file missing"
  fi
done

if [ "$failures" -eq 0 ]; then
  echo
  echo "bash -n $LAB_DIR/scripts/create-source-configmap.sh"
  if bash -n "$LAB_DIR/scripts/create-source-configmap.sh"; then
    check PASS "source configmap script" "syntax ok"
  else
    check FAIL "source configmap script" "syntax failed"
  fi
fi

if grep -R --line-number -E 'terraform[[:space:]]+apply' "$LAB_DIR/tekton" >/tmp/unit08-apply-scan.out 2>/dev/null; then
  cat /tmp/unit08-apply-scan.out
  check FAIL "terraform apply scan" "Tekton manifests must not execute terraform apply"
else
  check PASS "terraform apply scan" "no terraform apply command found in Tekton manifests"
fi

if grep -R --line-number --ignore-case \
  -E '(BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|password=|client_secret|api[_-]?key|kubeconfig|token:)' \
  "$LAB_DIR/tekton" "$LAB_DIR/scripts" >/tmp/unit08-secret-scan.out 2>/dev/null; then
  cat /tmp/unit08-secret-scan.out
  check WARN "secret scan" "review findings above; lab placeholders and explanatory text can be valid, real secrets are not"
else
  check PASS "secret scan" "no obvious credential patterns found"
fi

if command_exists kubectl; then
  echo
  echo "kubectl apply --dry-run=client -f $LAB_DIR/tekton"
  if kubectl apply --dry-run=client -f "$LAB_DIR/tekton"; then
    check PASS "kubectl dry-run" "Tekton manifests accepted by client dry-run"
  else
    check WARN "kubectl dry-run" "dry-run failed; install Tekton CRDs before validating Tekton resources against the API"
  fi
fi

if [ "$RUN_FUNCTIONAL" != "true" ]; then
  check WARN "functional validation" "skipped; set RUN_FUNCTIONAL=true to install/use Tekton in the approved Unit 08 scope"
else
  if [ "$failures" -eq 0 ]; then
    echo
    echo "microk8s status --wait-ready"
    if command_exists microk8s && microk8s status --wait-ready; then
      check PASS "microk8s" "ready"
    else
      check FAIL "microk8s" "not ready or command unavailable"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    echo
    echo "kubectl apply -f https://infra.tekton.dev/tekton-releases/pipeline/previous/$TEKTON_VERSION/release.yaml"
    if kubectl apply -f "https://infra.tekton.dev/tekton-releases/pipeline/previous/$TEKTON_VERSION/release.yaml"; then
      check PASS "tekton install" "Tekton Pipelines $TEKTON_VERSION applied"
    else
      check FAIL "tekton install" "install failed"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    echo
    echo "kubectl -n $TEKTON_NAMESPACE wait --for=condition=Available deployment --all --timeout=300s"
    if kubectl -n "$TEKTON_NAMESPACE" wait --for=condition=Available deployment --all --timeout=300s; then
      check PASS "tekton controllers" "deployments are Available"
    else
      check FAIL "tekton controllers" "controllers not Available"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    echo
    echo "bash $LAB_DIR/scripts/create-source-configmap.sh"
    if NAMESPACE="$NAMESPACE" CONFIGMAP_NAME="$SOURCE_CONFIGMAP" bash "$LAB_DIR/scripts/create-source-configmap.sh"; then
      check PASS "source configmap" "$SOURCE_CONFIGMAP refreshed"
    else
      check FAIL "source configmap" "creation failed"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    kubectl -n "$NAMESPACE" delete pipelinerun "$PIPELINE_RUN" --ignore-not-found=true >/dev/null 2>&1 || true
    echo
    echo "kubectl apply -f $LAB_DIR/tekton/serviceaccount.yaml -f $LAB_DIR/tekton/rbac.yaml -f $LAB_DIR/tekton/tasks.yaml -f $LAB_DIR/tekton/pipeline.yaml -f $LAB_DIR/tekton/pipelinerun.yaml"
    if kubectl apply \
      -f "$LAB_DIR/tekton/serviceaccount.yaml" \
      -f "$LAB_DIR/tekton/rbac.yaml" \
      -f "$LAB_DIR/tekton/tasks.yaml" \
      -f "$LAB_DIR/tekton/pipeline.yaml" \
      -f "$LAB_DIR/tekton/pipelinerun.yaml"; then
      check PASS "tekton resources" "applied"
    else
      check FAIL "tekton resources" "apply failed"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    wait_for_pipelinerun
  fi

  if [ "$failures" -eq 0 ]; then
    echo
    echo "kubectl -n $NAMESPACE get taskrun -l tekton.dev/pipelineRun=$PIPELINE_RUN"
    if kubectl -n "$NAMESPACE" get taskrun -l "tekton.dev/pipelineRun=$PIPELINE_RUN"; then
      check PASS "taskruns" "TaskRuns are observable"
    else
      check FAIL "taskruns" "TaskRuns not found"
    fi
  fi

  if [ "$failures" -eq 0 ]; then
    results="$(kubectl -n "$NAMESPACE" get pipelinerun "$PIPELINE_RUN" -o jsonpath='{.status.results[*].name}' 2>/dev/null || true)"
    case "$results" in
      *source-revision*helm-status*terraform-plan-summary* | *terraform-plan-summary*helm-status*source-revision*)
        check PASS "pipeline results" "non-sensitive results present: $results"
        ;;
      *)
        check FAIL "pipeline results" "expected results missing: $results"
        ;;
    esac
  fi

  if kubectl get namespace argocd >/dev/null 2>&1; then
    check FAIL "argocd namespace" "argocd must not be installed in Unit 08"
  else
    check PASS "argocd namespace" "not present"
  fi

  if kubectl -n "$NAMESPACE" get pvc platform-api-data >/dev/null 2>&1; then
    check PASS "platform-api-data" "main PVC still exists"
  else
    check FAIL "platform-api-data" "main PVC is missing"
  fi
fi

rm -f /tmp/unit08-apply-scan.out /tmp/unit08-secret-scan.out

echo
echo "Unit 08 validation summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi
