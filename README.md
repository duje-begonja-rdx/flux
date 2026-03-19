# flux

This repository is a local GitOps playground built around Flux, Helm, Kustomize, and `k3d`.

At a high level, it contains:

- reusable Helm charts for applications and infrastructure components
- Flux-managed cluster manifests for a local Kubernetes cluster
- example workloads, including a small Python app and Ethereum client setups
- observability stack definitions for Prometheus, Grafana, Loki, and Alloy
- bootstrap scripts for creating the local cluster and applying Flux resources

## Repository layout

- `apps/`
  Example application source code. Right now this includes `endpoint-counter`, a small Flask app with Docker assets.

- `charts/`
  Shared Helm charts. `common/` is a reusable app chart, and `ethereum-component/` is a reusable stateful client chart.

- `eth-comps/`
  A cleaner base/overlay structure for Ethereum environments.
  It contains:
  - `chart/` reusable Ethereum chart and per-client values files
  - `base/` common Flux resources
  - `overlays/` environment-specific compositions like `sepolia/` and `ephemery/`

- `clusters/local/`
  The local cluster composition. This is the entry point Flux applies for the `local` environment.

- `common/`
  Shared cluster resources, including observability releases and common namespaces/repositories.

- `scripts/`
  Helper scripts for creating a `k3d` cluster, installing Flux, and applying the local setup.

## What this repo demonstrates

- GitOps with Flux `GitRepository` and `HelmRelease`
- Helm chart reuse with client-specific values files
- Kustomize overlays for environment composition
- local Kubernetes operations with `k3d`
- app delivery and observability setup in a single repo

## Typical flow

1. Create the local cluster with the scripts in `scripts/`
2. Let Flux reconcile the manifests from this repository
3. Deploy applications and infrastructure through `HelmRelease` resources
4. Iterate by changing Git-managed manifests and reconciling Flux
