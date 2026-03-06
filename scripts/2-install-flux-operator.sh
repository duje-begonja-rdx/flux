#!/usr/bin/env bash
set -euo pipefail

KUBE_CONTEXT="${KUBE_CONTEXT:-k3d-macOS-tf}"
NAMESPACE="${NAMESPACE:-flux-system}"
RELEASE_NAME="${RELEASE_NAME:-flux-operator}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1" >&2
    exit 1
  fi
}

require_cmd kubectl
require_cmd helm

kubectl config use-context "$KUBE_CONTEXT" >/dev/null

helm upgrade --install "$RELEASE_NAME" oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --set web.ingress.enabled=true \
  --set-string web.ingress.className=traefik \
  --set-string web.ingress.hosts[0].host=flux.localhost \
  --set-string web.ingress.hosts[0].paths[0].path=/ \
  --set-string web.ingress.hosts[0].paths[0].pathType=Prefix

kubectl -n "$NAMESPACE" rollout status deploy/"$RELEASE_NAME" --timeout=5m
kubectl wait --for=condition=Established crd/fluxinstances.fluxcd.controlplane.io --timeout=5m
