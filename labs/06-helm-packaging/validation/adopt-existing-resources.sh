#!/usr/bin/env bash
set -eu

NAMESPACE="${NAMESPACE:-platform-training}"
RELEASE="${RELEASE:-platform-api-local}"

echo "Adopting existing Unit 05 resources into Helm release metadata"
echo "Namespace: $NAMESPACE"
echo "Release: $RELEASE"
echo "This script only adds labels and annotations required by Helm. It does not delete resources or PVC data."
echo

kubectl label namespace "$NAMESPACE" app.kubernetes.io/managed-by=Helm --overwrite
kubectl annotate namespace "$NAMESPACE" meta.helm.sh/release-name="$RELEASE" --overwrite
kubectl annotate namespace "$NAMESPACE" meta.helm.sh/release-namespace="$NAMESPACE" --overwrite

for resource in \
  configmap/platform-api-config \
  secret/platform-api-secret \
  persistentvolumeclaim/platform-api-data \
  deployment.apps/platform-api \
  service/platform-api \
  ingress.networking.k8s.io/platform-api \
  poddisruptionbudget.policy/platform-api
do
  kubectl -n "$NAMESPACE" label "$resource" app.kubernetes.io/managed-by=Helm --overwrite
  kubectl -n "$NAMESPACE" annotate "$resource" meta.helm.sh/release-name="$RELEASE" --overwrite
  kubectl -n "$NAMESPACE" annotate "$resource" meta.helm.sh/release-namespace="$NAMESPACE" --overwrite
done

echo
echo "Adoption metadata applied. Run helm upgrade --install next."
