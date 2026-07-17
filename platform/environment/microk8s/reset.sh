#!/usr/bin/env bash
set -u

confirm_reset=0

for arg in "$@"; do
  case "$arg" in
    --confirm-reset)
      confirm_reset=1
      ;;
    *)
      printf '[FAIL] Unknown argument: %s\n' "$arg"
      echo "Usage: bash platform/environment/microk8s/reset.sh --confirm-reset"
      exit 1
      ;;
  esac
done

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

run_microk8s() {
  microk8s "$@" || sudo microk8s "$@"
}

echo "Unit 00 MicroK8s reset"
echo
echo "This operation resets the local MicroK8s cluster state."
echo "It may remove Kubernetes resources stored in MicroK8s."
echo "It does not uninstall MicroK8s, remove Ubuntu, remove WSL or touch Windows."
echo

if [ "$confirm_reset" -ne 1 ]; then
  echo "[INFO] Dry run only. Re-run with --confirm-reset to execute:"
  echo "bash platform/environment/microk8s/reset.sh --confirm-reset"
  exit 0
fi

if ! command_exists microk8s; then
  echo "[FAIL] microk8s command not found"
  exit 1
fi

echo "Executing: microk8s reset"
if run_microk8s reset; then
  echo "[PASS] microk8s reset completed"
  echo "Re-run configuration when needed:"
  echo "bash platform/environment/microk8s/configure.sh"
  exit 0
fi

echo "[FAIL] microk8s reset failed"
exit 1
