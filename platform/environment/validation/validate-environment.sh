#!/usr/bin/env bash
set -u

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
environment_dir="$(CDPATH= cd -- "$script_dir/.." && pwd)"

failures=0

run_step() {
  local name="$1"
  local command_path="$2"

  echo "==> $name"
  if [ ! -x "$command_path" ]; then
    echo "[FAIL] $command_path is not executable or does not exist"
    failures=$((failures + 1))
    return
  fi

  "$command_path"
  local exit_code=$?
  if [ "$exit_code" -ne 0 ]; then
    echo "[FAIL] $name exited with $exit_code"
    failures=$((failures + 1))
  else
    echo "[PASS] $name completed"
  fi
  echo
}

echo "Unit 00 integrated environment validation"
echo "This script is read-only and runs Linux-side checks only."
echo

run_step "Ubuntu/WSL prerequisites" "$environment_dir/linux/check-prerequisites.sh"

if [ -x "$environment_dir/microk8s/validate.sh" ]; then
  run_step "MicroK8s and kubectl" "$environment_dir/microk8s/validate.sh"
else
  echo "[WARN] $environment_dir/microk8s/validate.sh is not executable or does not exist"
  echo
fi

if [ "$failures" -gt 0 ]; then
  echo "Integrated validation completed with $failures failure(s)."
  exit 1
fi

echo "Integrated validation completed without blocking failures."
exit 0
