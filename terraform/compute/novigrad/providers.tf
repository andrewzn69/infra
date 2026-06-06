provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}

provider "helm" {
  kubernetes = {
    host                   = yamldecode(module.oke.kubeconfig).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(module.oke.kubeconfig).clusters[0].cluster["certificate-authority-data"])
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args        = ["ce", "cluster", "generate-token", "--cluster-id", module.oke.cluster_id, "--region", var.region]
      env = {
        OCI_CLI_USER        = var.user_ocid
        OCI_CLI_FINGERPRINT = var.fingerprint
        OCI_CLI_TENANCY     = var.tenancy_ocid
        OCI_CLI_REGION      = var.region
        OCI_CLI_KEY_CONTENT = var.private_key
      }
    }
  }
}

provider "tailscale" {
  oauth_client_id     = var.tailscale_oauth_client_id
  oauth_client_secret = var.tailscale_oauth_client_secret
  tailnet             = var.tailnet
}
