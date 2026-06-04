provider "helm" {
  kubernetes = {
    host                   = module.talos_cluster.kubeconfig.host
    client_certificate     = module.talos_cluster.kubeconfig.client_certificate
    client_key             = module.talos_cluster.kubeconfig.client_key
    cluster_ca_certificate = module.talos_cluster.kubeconfig.cluster_ca_certificate
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
  insecure  = true
}

provider "talos" {}

provider "tailscale" {
  oauth_client_id     = var.tailscale_oauth_client_id
  oauth_client_secret = var.tailscale_oauth_client_secret
  tailnet             = var.tailnet
}
