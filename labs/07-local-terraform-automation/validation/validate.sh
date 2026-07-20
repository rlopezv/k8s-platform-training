#!/usr/bin/env bash
set -u

TF_DIR="${TF_DIR:-labs/07-local-terraform-automation/terraform}"
TFVARS="${TFVARS:-terraform.tfvars.example}"
NAMESPACE="${NAMESPACE:-platform-training}"
RELEASE="${RELEASE:-platform-api-local}"
CHART_DIR="${CHART_DIR:-labs/06-helm-packaging/chart/platform-api}"
DEPLOYMENT="${DEPLOYMENT:-platform-api}"
SERVICE="${SERVICE:-platform-api}"
INGRESS="${INGRESS:-platform-api}"
PDB="${PDB:-platform-api}"
PVC="${PVC:-platform-api-data}"

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

echo "Unit 07 Terraform local automation validation"
echo "This validation checks Terraform files, local state when available, Helm release state and Kubernetes resources."
echo "It does not run terraform destroy, delete PVCs, create cloud resources or reset MicroK8s."
echo

for cmd in terraform helm kubectl; do
  if command_exists "$cmd"; then
    check PASS "$cmd" "available at $(command -v "$cmd")"
  else
    check FAIL "$cmd" "command not found"
  fi
done

for file in versions.tf providers.tf variables.tf main.tf outputs.tf terraform.tfvars.example values/platform-api-values.yaml.tftpl .gitignore; do
  if [ -f "$TF_DIR/$file" ]; then
    check PASS "terraform file" "$TF_DIR/$file exists"
  else
    check FAIL "terraform file" "$TF_DIR/$file missing"
  fi
done

if [ -f "$CHART_DIR/Chart.yaml" ]; then
  check PASS "chart" "$CHART_DIR/Chart.yaml exists"
else
  check FAIL "chart" "$CHART_DIR/Chart.yaml missing"
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "terraform -chdir=$TF_DIR fmt -check -recursive"
  if terraform -chdir="$TF_DIR" fmt -check -recursive; then
    check PASS "terraform fmt" "configuration is formatted"
  else
    check FAIL "terraform fmt" "format check failed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "terraform -chdir=$TF_DIR validate"
  if terraform -chdir="$TF_DIR" validate; then
    check PASS "terraform validate" "configuration is valid"
  else
    check WARN "terraform validate" "validate failed; run terraform init first if providers are not installed"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "terraform -chdir=$TF_DIR state list"
  if terraform -chdir="$TF_DIR" state list | tee /tmp/unit07-terraform-state.out; then
    if grep -q '^helm_release.platform_api$' /tmp/unit07-terraform-state.out; then
      check PASS "terraform state" "helm_release.platform_api is managed by Terraform"
    else
      check WARN "terraform state" "helm_release.platform_api not found; run terraform apply or import existing release if needed"
    fi
  else
    check WARN "terraform state" "state not available yet; run terraform apply after plan review"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "helm status $RELEASE --namespace $NAMESPACE"
  if helm status "$RELEASE" --namespace "$NAMESPACE"; then
    check PASS "helm release" "$RELEASE exists in $NAMESPACE"
  else
    check WARN "helm release" "$RELEASE is not installed yet or cluster is unavailable"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo
  echo "kubectl -n $NAMESPACE rollout status deployment/$DEPLOYMENT"
  if kubectl -n "$NAMESPACE" rollout status "deployment/$DEPLOYMENT" --timeout=180s; then
    check PASS "deployment rollout" "$DEPLOYMENT is available"
  else
    check WARN "deployment rollout" "$DEPLOYMENT is not available or cluster is unavailable"
  fi
fi

if [ "$failures" -eq 0 ]; then
  for resource in "service/$SERVICE" "ingress/$INGRESS" "pvc/$PVC" "pdb/$PDB"; do
    if kubectl -n "$NAMESPACE" get "$resource" >/dev/null 2>&1; then
      check PASS "$resource" "exists"
    else
      check WARN "$resource" "missing or cluster unavailable"
    fi
  done
fi

if grep -R --line-number --ignore-case \
  --exclude-dir=.terraform \
  --exclude='terraform.tfstate*' \
  --exclude='*.tfplan' \
  --exclude='*.plan' \
  -E '(BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY|password=|client_secret|api[_-]?key)' "$TF_DIR" >/tmp/unit07-secret-scan.out 2>/dev/null; then
  cat /tmp/unit07-secret-scan.out
  check WARN "secret scan" "review findings above; lab placeholders are allowed, real secrets are not"
else
  check PASS "secret scan" "no obvious real credential patterns found in Terraform files"
fi

rm -f /tmp/unit07-terraform-state.out /tmp/unit07-secret-scan.out

echo
echo "Unit 07 validation summary: $failures failure(s), $warnings warning(s)."

if [ "$failures" -gt 0 ]; then
  exit 1
fi
