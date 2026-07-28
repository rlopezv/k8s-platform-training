#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-platform-training}"
CONFIGMAP_NAME="${CONFIGMAP_NAME:-platform-api-ci-source}"
TMP_DIR="$(mktemp -d)"
BUNDLE="$TMP_DIR/source.tar.gz"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

require_file() {
  if [ ! -e "$1" ]; then
    printf 'Missing required path: %s\n' "$1" >&2
    exit 1
  fi
}

require_file "labs/06-helm-packaging/chart/platform-api/Chart.yaml"
require_file "labs/07-local-terraform-automation/terraform/main.tf"
require_file "labs/07-local-terraform-automation/terraform/terraform.tfvars.example"
require_file "labs/08-tekton-continuous-integration/tekton/pipeline.yaml"

tar \
  --exclude='.terraform' \
  --exclude='terraform.tfstate' \
  --exclude='terraform.tfstate.backup' \
  --exclude='*.tfplan' \
  --exclude='*.plan' \
  -czf "$BUNDLE" \
  labs/06-helm-packaging/chart/platform-api \
  labs/07-local-terraform-automation/terraform

kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"

kubectl -n "$NAMESPACE" create configmap "$CONFIGMAP_NAME" \
  --from-file=source.tar.gz="$BUNDLE" \
  --dry-run=client \
  -o yaml |
  kubectl apply -f -

printf 'ConfigMap %s/%s refreshed with Helm and Terraform sources.\n' "$NAMESPACE" "$CONFIGMAP_NAME"
