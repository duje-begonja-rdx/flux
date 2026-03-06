provider "helm" {
  kubernetes = {
    host                   = resource.k3d_cluster.cluster.host
    client_certificate     = base64decode(resource.k3d_cluster.cluster.client_certificate)
    client_key             = base64decode(resource.k3d_cluster.cluster.client_key)
    cluster_ca_certificate = base64decode(resource.k3d_cluster.cluster.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = resource.k3d_cluster.cluster.host
  client_certificate     = base64decode(resource.k3d_cluster.cluster.client_certificate)
  client_key             = base64decode(resource.k3d_cluster.cluster.client_key)
  cluster_ca_certificate = base64decode(resource.k3d_cluster.cluster.cluster_ca_certificate)
}