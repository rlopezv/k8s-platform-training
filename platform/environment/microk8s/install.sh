#!/usr/bin/env bash
set -u

MICROK8S_CHANNEL="${MICROK8S_CHANNEL:-1.35/stable}"
KUBECTL_CHANNEL="${KUBECTL_CHANNEL:-1.35/stable}"

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

require_command() {
  local command_name="$1"
  if command_exists "$command_name"; then
    check PASS "$command_name" "available at $(command -v "$command_name")"
  else
    check FAIL "$command_name" "command not found"
  fi
}

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

validate_ubuntu() {
  if [ ! -r /etc/os-release ]; then
    check FAIL "Ubuntu" "/etc/os-release not readable"
    return
  fi

  # shellcheck disable=SC1091
  . /etc/os-release
  local os_id="${ID:-unknown}"
  local os_version="${VERSION_ID:-unknown}"
  local os_name="${PRETTY_NAME:-unknown}"

  if [ "$os_id" != "ubuntu" ]; then
    check FAIL "Ubuntu" "expected Ubuntu, found $os_name"
    return
  fi

  case "$os_version" in
    24.04)
      check PASS "Ubuntu" "$os_name is the baseline target"
      ;;
    22.04)
      check WARN "Ubuntu" "$os_name is accepted when already present, but 24.04 LTS is the baseline"
      ;;
    *)
      check WARN "Ubuntu" "$os_name is not the baseline target"
      ;;
  esac
}

validate_dns() {
  local status_when_missing="$1"

  if ! command_exists getent; then
    check WARN "DNS resolution" "getent not available; cannot verify snapcraft.io"
    return
  fi

  if getent hosts snapcraft.io >/dev/null 2>&1; then
    check PASS "DNS resolution" "snapcraft.io resolves"
  else
    check "$status_when_missing" "DNS resolution" "snapcraft.io does not resolve; review DNS, proxy, VPN or firewall before installing from snap"
  fi
}

print_summary_and_exit_on_failures() {
  echo
  echo "Pre-install summary: $failures failure(s), $warnings warning(s)."
  if [ "$failures" -gt 0 ]; then
    echo "MicroK8s installation blocked until failures are resolved."
    exit 1
  fi
}

install_snap_if_missing() {
  local snap_name="$1"
  local channel="$2"
  local classic_arg="$3"

  if snap list "$snap_name" >/dev/null 2>&1; then
    check PASS "$snap_name" "snap already installed"
    snap list "$snap_name" || true
    return
  fi

  echo "Installing $snap_name from channel $channel."
  # shellcheck disable=SC2086
  if sudo snap install "$snap_name" $classic_arg --channel="$channel"; then
    check PASS "$snap_name" "installed from channel $channel"
  else
    check FAIL "$snap_name" "snap install failed"
  fi
}

echo "Unit 00 MicroK8s and kubectl installation"
echo "This script modifies Ubuntu only when prerequisites pass."
echo "MicroK8s channel: $MICROK8S_CHANNEL"
echo "kubectl channel: $KUBECTL_CHANNEL"
echo

needs_snap_download=0
if ! command_exists snap; then
  needs_snap_download=1
else
  if ! snap list microk8s >/dev/null 2>&1; then
    needs_snap_download=1
  fi
  if ! snap list kubectl >/dev/null 2>&1; then
    needs_snap_download=1
  fi
fi

if is_wsl; then
  check PASS "WSL environment" "Kernel reports Microsoft/WSL"
else
  check FAIL "WSL environment" "MicroK8s baseline for Unit 00 expects Ubuntu on WSL2"
fi

validate_ubuntu
require_command sudo
require_command snap
if [ "$needs_snap_download" -eq 1 ]; then
  validate_dns FAIL
else
  validate_dns WARN
fi

print_summary_and_exit_on_failures

install_snap_if_missing "microk8s" "$MICROK8S_CHANNEL" "--classic"
install_snap_if_missing "kubectl" "$KUBECTL_CHANNEL" "--classic"

echo
echo "Install summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

echo "Installation step completed. Continue with:"
echo "bash platform/environment/microk8s/configure.sh"
exit 0
