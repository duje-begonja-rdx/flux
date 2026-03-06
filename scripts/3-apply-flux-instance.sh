#!/usr/bin/env bash
set -euo pipefail

KUBE_CONTEXT="${KUBE_CONTEXT:-k3d-macOS-tf}"
GIT_URL="${GIT_URL:-https://github.com/duje-begonja-rdx/flux.git}"
GIT_REF="${GIT_REF:-refs/heads/main}"
SYNC_PATH="${SYNC_PATH:-clusters/local}"
INSTANCE_NAME="${INSTANCE_NAME:-flux}"
INSTANCE_NAMESPACE="${INSTANCE_NAMESPACE:-flux-system}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1" >&2
    exit 1
  fi
}

require_cmd kubectl

kubectl config use-context "$KUBE_CONTEXT" >/dev/null

kubectl apply -f - <<EOF
apiVersion: fluxcd.controlplane.io/v1
kind: FluxInstance
metadata:
  name: $INSTANCE_NAME
  namespace: $INSTANCE_NAMESPACE
spec:
  distribution:
    version: 2.7.x
    registry: ghcr.io/fluxcd
    artifact: oci://ghcr.io/controlplaneio-fluxcd/flux-operator-manifests
  cluster:
    type: kubernetes
    size: medium
  sync:
    kind: GitRepository
    url: $GIT_URL
    ref: $GIT_REF
    path: $SYNC_PATH
EOF

kubectl -n "$INSTANCE_NAMESPACE" wait --for=condition=Ready "fluxinstance/$INSTANCE_NAME" --timeout=10m
