#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-macOS-tf}"
K3S_IMAGE="${K3S_IMAGE:-rancher/k3s:v1.35.2-k3s1}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1" >&2
    exit 1
  fi
}

require_cmd k3d
require_cmd kubectl

if k3d cluster list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$CLUSTER_NAME"; then
  echo "Cluster '$CLUSTER_NAME' already exists. Skipping create."
else
  tmp_cfg="$(mktemp)"
  trap 'rm -f "$tmp_cfg"' EXIT

  cat >"$tmp_cfg" <<EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
servers: 1
agents: 0
image: $K3S_IMAGE
ports:
  - port: 8080:80
    nodeFilters:
      - loadbalancer
  - port: 8443:443
    nodeFilters:
      - loadbalancer
options:
  runtime:
    extraArgs:
      - "--cpus=4"
      - "--memory=8g"
    nodeFilters:
      - server:*
EOF

  k3d cluster create "$CLUSTER_NAME" --config "$tmp_cfg"
fi

kubectl config use-context "k3d-$CLUSTER_NAME" >/dev/null
echo "Active context: $(kubectl config current-context)"
kubectl get nodes
