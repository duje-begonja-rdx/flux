resource "k3d_cluster" "cluster" {
  name = "macOS-tf"
  # See https://k3d.io/v5.4.6/usage/configfile/#config-options
  k3d_config = <<EOF
apiVersion: k3d.io/v1alpha5
kind: Simple
servers: 1
agents: 0
image: rancher/k3s:v1.35.2-k3s1
# Expose ports 80 via 8080 and 443 via 8443.
ports:
  - port: 8080:80
    nodeFilters:
      - loadbalancer
  - port: 8443:443
    nodeFilters:
      - loadbalancer
EOF
}

resource "helm_release" "flux_operator" {
  name             = "flux-operator"
  namespace        = "flux-system"
  create_namespace = true

  repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  chart      = "flux-operator"

  set = [
    {
      name  = "web.ingress.enabled"
      value = "true"
    },
    {
      name  = "web.ingress.className"
      value = "traefik"
    },
    {
      name  = "web.ingress.hosts[0].host"
      value = "flux.localhost"
    },
    {
    name  = "web.ingress.hosts[0].paths[0].path"
    value = "/"
  },
  {
    name  = "web.ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
  }
  ]
}

resource "kubernetes_manifest" "flux_instance" {
  manifest = {
    apiVersion = "fluxcd.controlplane.io/v1"
    kind       = "FluxInstance"

    metadata = {
      name      = "flux"
      namespace = "flux-system"
    }

    spec = {
      distribution = {
        version  = "2.7.x"
        registry = "ghcr.io/fluxcd"
        artifact = "oci://ghcr.io/controlplaneio-fluxcd/flux-operator-manifests"
      }

      cluster = {
        type = "kubernetes"
        size = "medium"
      }

      sync = {
        kind = "GitRepository"
        url  = "https://github.com/duje-begonja-rdx/flux.git"
        ref  = "refs/heads/main"
        path = "clusters/local"
      }
    }
  }

  wait {
    fields = {
      "status.conditions[0].type"   = "Ready"
      "status.conditions[0].status" = "True"
    }
  }
}
