#!/usr/bin/env bash
set -u

HELM_VERSION="${HELM_VERSION:-v3.21.0}"

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

detect_arch() {
  case "$(uname -m 2>/dev/null || printf unknown)" in
    x86_64|amd64) printf 'amd64' ;;
    aarch64|arm64) printf 'arm64' ;;
    *)
      return 1
      ;;
  esac
}

helm_matches_target() {
  command_exists helm && helm version --short 2>/dev/null | grep -q "^${HELM_VERSION}"
}

require_command() {
  local command_name="$1"
  if command_exists "$command_name"; then
    check PASS "$command_name" "available at $(command -v "$command_name")"
  else
    check FAIL "$command_name" "command not found"
  fi
}

echo "Unit 00 Helm installation"
echo "This script installs Helm as a local CLI only. It does not create charts or releases."
echo "Helm target version: $HELM_VERSION"
echo

if helm_matches_target; then
  check PASS "helm" "target version already installed: $(helm version --short 2>/dev/null)"
  echo
  echo "Helm install summary: $failures failure(s), $warnings warning(s)."
  exit 0
fi

require_command curl
require_command tar
require_command sudo
require_command sha256sum

helm_arch="$(detect_arch || true)"
if [ -z "${helm_arch:-}" ]; then
  check FAIL "Architecture" "unsupported architecture: $(uname -m 2>/dev/null || printf unknown)"
fi

echo
echo "Pre-install summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

archive="helm-${HELM_VERSION}-linux-${helm_arch}.tar.gz"
base_url="https://get.helm.sh"

echo "Downloading $archive"
curl -fsSLo "$tmp_dir/$archive" "$base_url/$archive"
curl -fsSLo "$tmp_dir/$archive.sha256sum" "$base_url/$archive.sha256sum"

(
  cd "$tmp_dir" || exit 1
  sha256sum -c "$archive.sha256sum"
) || {
  check FAIL "Helm checksum" "SHA256 verification failed"
  exit 1
}
check PASS "Helm checksum" "SHA256 verification completed"

tar -xzf "$tmp_dir/$archive" -C "$tmp_dir"
sudo install -m 0755 "$tmp_dir/linux-${helm_arch}/helm" /usr/local/bin/helm

if helm_matches_target; then
  check PASS "helm" "installed: $(helm version --short 2>/dev/null)"
else
  check FAIL "helm" "installed binary does not report $HELM_VERSION"
fi

echo
echo "Helm install summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
