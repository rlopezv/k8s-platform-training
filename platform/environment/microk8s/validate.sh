#!/usr/bin/env bash
set -u

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

run_microk8s_readonly() {
  microk8s "$@" || sudo microk8s "$@"
}

run_microk8s_wait_ready() {
  if command_exists timeout; then
    timeout 180 microk8s status --wait-ready || timeout 180 sudo microk8s status --wait-ready
  else
    microk8s status --wait-ready || sudo microk8s status --wait-ready
  fi
}

validate_microk8s() {
  if run_microk8s_wait_ready; then
    check PASS "microk8s status" "cluster is ready"
  else
    check FAIL "microk8s status" "microk8s did not report ready state"
  fi

  echo
  echo "microk8s version"
  if run_microk8s_readonly version; then
    check PASS "microk8s version" "version command completed"
  else
    check FAIL "microk8s version" "version command failed"
  fi

  echo
  echo "microk8s status"
  status_output="$(run_microk8s_readonly status 2>/dev/null || true)"
  printf '%s\n' "$status_output"
  if printf '%s\n' "$status_output" | grep -Eq 'dns:[[:space:]]+enabled'; then
    check PASS "MicroK8s dns addon" "dns is enabled"
  else
    check FAIL "MicroK8s dns addon" "dns is not reported as enabled"
  fi
}

validate_kubectl() {
  echo
  echo "kubectl version --client"
  if kubectl version --client; then
    check PASS "kubectl client" "client version available"
  else
    check FAIL "kubectl client" "client version command failed"
  fi

  echo
  echo "kubectl get nodes"
  if kubectl get nodes; then
    check PASS "kubectl nodes" "node query completed"
  else
    check FAIL "kubectl nodes" "node query failed"
  fi

  echo
  echo "kubectl get namespaces"
  if kubectl get namespaces; then
    check PASS "kubectl namespaces" "namespace query completed"
  else
    check FAIL "kubectl namespaces" "namespace query failed"
  fi
}

echo "Unit 00 MicroK8s and kubectl validation"
echo "This script is read-only and does not install or configure components."
echo

if command_exists microk8s; then
  check PASS "microk8s" "available at $(command -v microk8s)"
else
  check FAIL "microk8s" "command not found"
fi

if command_exists kubectl; then
  check PASS "kubectl" "available at $(command -v kubectl)"
else
  check FAIL "kubectl" "command not found"
fi

if [ "$failures" -eq 0 ]; then
  validate_microk8s
  validate_kubectl
fi

echo
echo "MicroK8s validation summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
