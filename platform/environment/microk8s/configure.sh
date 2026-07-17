#!/usr/bin/env bash
set -u

failures=0
warnings=0
needs_new_session=0

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

microk8s_needs_sudo() {
  ! id -nG "$USER" | tr ' ' '\n' | grep -qx microk8s
}

run_microk8s() {
  if microk8s_needs_sudo; then
    sudo microk8s "$@"
  else
    local output_file
    output_file="$(mktemp)"
    if microk8s "$@" >"$output_file" 2>&1; then
      cat "$output_file"
      rm -f "$output_file"
    else
      rm -f "$output_file"
      sudo microk8s "$@"
    fi
  fi
}

microk8s_output() {
  if microk8s_needs_sudo; then
    sudo microk8s "$@"
  else
    local output_file
    output_file="$(mktemp)"
    if microk8s "$@" >"$output_file" 2>&1; then
      cat "$output_file"
      rm -f "$output_file"
    else
      rm -f "$output_file"
      sudo microk8s "$@"
    fi
  fi
}

ensure_microk8s_group() {
  if ! getent group microk8s >/dev/null 2>&1; then
    check WARN "microk8s group" "group not found yet; snap may still be initializing"
    return
  fi

  if id -nG "$USER" | tr ' ' '\n' | grep -qx microk8s; then
    check PASS "microk8s group" "$USER already belongs to microk8s"
    return
  fi

  if sudo usermod -a -G microk8s "$USER"; then
    check WARN "microk8s group" "$USER added to microk8s; close and reopen the Ubuntu session before relying on direct microk8s access"
    needs_new_session=1
  else
    check FAIL "microk8s group" "failed to add $USER to microk8s"
  fi
}

enable_dns() {
  echo "Enabling MicroK8s addon: dns"
  if run_microk8s enable dns; then
    check PASS "MicroK8s dns addon" "enable command completed"
  else
    check FAIL "MicroK8s dns addon" "enable command failed"
  fi
}

write_kubeconfig() {
  local kube_dir="$HOME/.kube"
  local kube_config="$kube_dir/config"
  local tmp_config="$kube_config.tmp"
  local config_content

  if ! mkdir -p "$kube_dir"; then
    check FAIL "kubeconfig directory" "failed to create $kube_dir"
    return
  fi

  config_content="$(microk8s_output config)"
  if [ -z "$config_content" ]; then
    check FAIL "kubeconfig" "microk8s config returned empty output"
    return
  fi

  if printf '%s\n' "$config_content" >"$tmp_config" && mv "$tmp_config" "$kube_config"; then
    chmod 600 "$kube_config"
    check PASS "kubeconfig" "written to $kube_config"
  else
    rm -f "$tmp_config"
    check FAIL "kubeconfig" "failed to write $kube_config"
  fi
}

echo "Unit 00 MicroK8s configuration"
echo "This script configures MicroK8s permissions, dns addon and kubectl kubeconfig."
echo

if ! command_exists microk8s; then
  check FAIL "microk8s" "command not found; run platform/environment/microk8s/install.sh first"
fi

if ! command_exists kubectl; then
  check FAIL "kubectl" "command not found; run platform/environment/microk8s/install.sh first"
fi

if [ "$failures" -eq 0 ]; then
  ensure_microk8s_group
  enable_dns
  write_kubeconfig
fi

echo
echo "Configuration summary: $failures failure(s), $warnings warning(s)."
if [ "$needs_new_session" -eq 1 ]; then
  echo "Important: reopen the Ubuntu session so group membership is applied."
fi

if [ "$failures" -gt 0 ]; then
  exit 1
fi

echo "Configuration step completed. Continue with:"
echo "bash platform/environment/microk8s/validate.sh"
exit 0
