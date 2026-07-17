#!/usr/bin/env bash
set -u

HELM_MAJOR_MINOR="${HELM_MAJOR_MINOR:-3.21}"
TERRAFORM_MAJOR_MINOR="${TERRAFORM_MAJOR_MINOR:-1.15}"

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

validate_helm() {
  if ! command_exists helm; then
    check FAIL "helm" "command not found"
    return
  fi

  local helm_short
  helm_short="$(helm version --short 2>/dev/null || true)"
  printf '%s\n' "$helm_short"
  if printf '%s' "$helm_short" | grep -q "^v${HELM_MAJOR_MINOR}\."; then
    check PASS "helm" "$helm_short"
  else
    check FAIL "helm" "${helm_short:-available}; expected v${HELM_MAJOR_MINOR}.x"
  fi
}

validate_terraform() {
  if ! command_exists terraform; then
    check FAIL "terraform" "command not found"
    return
  fi

  local terraform_version
  terraform_version="$(terraform version -json 2>/dev/null | sed -n 's/.*"terraform_version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' || true)"
  if [ -z "$terraform_version" ]; then
    terraform_version="$(terraform version 2>/dev/null | head -n1 | awk '{print $2}' | sed 's/^v//' || true)"
  fi

  terraform version | head -n1
  if printf '%s' "$terraform_version" | grep -q "^${TERRAFORM_MAJOR_MINOR}\."; then
    check PASS "terraform" "$terraform_version"
  else
    check FAIL "terraform" "${terraform_version:-available}; expected ${TERRAFORM_MAJOR_MINOR}.x"
  fi
}

echo "Unit 00 Helm and Terraform validation"
echo "This script is read-only and does not create charts, modules, backends or resources."
echo

validate_helm
validate_terraform

echo
echo "Tools validation summary: $failures failure(s), $warnings warning(s)."
if [ "$failures" -gt 0 ]; then
  exit 1
fi

exit 0
