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

version_ge() {
  local current="$1"
  local minimum="$2"
  [ "$(printf '%s\n%s\n' "$minimum" "$current" | sort -V | head -n1)" = "$minimum" ]
}

echo "Unit 00 Ubuntu/WSL prerequisite check"
echo "This script is read-only and does not modify the system."
echo

if grep -qi microsoft /proc/version 2>/dev/null || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  check PASS "WSL environment" "Kernel reports Microsoft/WSL"
else
  check WARN "WSL environment" "Microsoft/WSL marker not detected"
fi

if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  os_name="${PRETTY_NAME:-unknown}"
  os_id="${ID:-unknown}"
  os_version="${VERSION_ID:-unknown}"
  if [ "$os_id" = "ubuntu" ]; then
    if [ "$os_version" = "24.04" ]; then
      check PASS "Ubuntu version" "$os_name is the baseline target"
    elif [ "$os_version" = "22.04" ]; then
      check WARN "Ubuntu version" "$os_name is accepted when already present, but 24.04 LTS is the baseline"
    else
      check WARN "Ubuntu version" "$os_name is not the baseline target"
    fi
  else
    check FAIL "Linux distribution" "Expected Ubuntu, found $os_name"
  fi
else
  check FAIL "Linux distribution" "/etc/os-release not readable"
fi

architecture="$(uname -m 2>/dev/null || printf unknown)"
case "$architecture" in
  x86_64|aarch64|arm64)
    check PASS "Architecture" "$architecture"
    ;;
  *)
    check WARN "Architecture" "$architecture; verify tool binaries before continuing"
    ;;
esac

if command_exists systemctl; then
  if systemctl is-system-running >/dev/null 2>&1; then
    check PASS "systemd" "systemctl is available and system is running"
  else
    system_state="$(systemctl is-system-running 2>/dev/null || true)"
    check WARN "systemd" "systemctl available, state: ${system_state:-unknown}"
  fi
else
  check WARN "systemd" "systemctl not available; MicroK8s may require WSL systemd support"
fi

if command_exists snap; then
  snap_version="$(snap version 2>/dev/null | head -n1 | awk '{print $2}' || true)"
  check PASS "snap" "snap available${snap_version:+ ($snap_version)}"
else
  check WARN "snap" "snap command not found"
fi

for tool in git curl tar gzip; do
  if command_exists "$tool"; then
    tool_path="$(command -v "$tool")"
    check PASS "$tool" "$tool_path"
  else
    check WARN "$tool" "command not found"
  fi
done

if command_exists kubectl; then
  kubectl_output="$(kubectl version --client --output=yaml 2>/dev/null | head -n5 || kubectl version --client 2>/dev/null || true)"
  check PASS "kubectl" "available"
  printf '%s\n' "$kubectl_output"
else
  check WARN "kubectl" "command not found; Unit 00 will install or configure kubectl"
fi

if command_exists microk8s; then
  check PASS "microk8s" "command available"
  microk8s version 2>/dev/null || true
else
  check WARN "microk8s" "command not found; expected before installation"
fi

if command_exists helm; then
  helm_version="$(helm version --short 2>/dev/null || true)"
  if printf '%s' "$helm_version" | grep -q 'v3\.21\.'; then
    check PASS "helm" "$helm_version"
  else
    check WARN "helm" "${helm_version:-available}; baseline target is 3.21.x"
  fi
else
  check WARN "helm" "command not found; Unit 00 will install or validate Helm 3.21.x"
fi

if command_exists terraform; then
  terraform_version="$(terraform version -json 2>/dev/null | sed -n 's/.*"terraform_version":"\([^"]*\)".*/\1/p' || true)"
  if [ -z "$terraform_version" ]; then
    terraform_version="$(terraform version 2>/dev/null | head -n1 | awk '{print $2}' | sed 's/^v//' || true)"
  fi

  if printf '%s' "$terraform_version" | grep -q '^1\.15\.'; then
    check PASS "terraform" "$terraform_version"
  else
    check WARN "terraform" "${terraform_version:-available}; baseline target is 1.15.x"
  fi
else
  check WARN "terraform" "command not found; Unit 00 will install or validate Terraform 1.15.x"
fi

if command_exists df; then
  free_kb="$(df -Pk "$HOME" 2>/dev/null | awk 'NR==2 {print $4}')"
  if [ -n "${free_kb:-}" ]; then
    free_gb=$((free_kb / 1024 / 1024))
    if [ "$free_gb" -ge 30 ]; then
      check PASS "Home filesystem free space" "${free_gb} GB free"
    else
      check WARN "Home filesystem free space" "${free_gb} GB free; review before installing MicroK8s"
    fi
  fi
fi

if command_exists getent; then
  if getent hosts snapcraft.io >/dev/null 2>&1; then
    check PASS "DNS resolution" "snapcraft.io resolves"
  else
    check WARN "DNS resolution" "snapcraft.io did not resolve"
  fi
fi

echo
echo "Summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
