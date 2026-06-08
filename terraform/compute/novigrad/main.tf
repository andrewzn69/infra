resource "tailscale_tailnet_key" "node" {
  description   = "novigrad novigrad-node registration" # needs to be hardcoded because acl in tailscale
  ephemeral     = false
  expiry        = 2000
  preauthorized = true
  reusable      = true
  tags          = ["tag:novigrad-node"]
}

module "oke" {
  source = "git::https://github.com/andrewzn69/tf-oci-free-oke.git?ref=v0.1.4"

  compartment_id           = var.compartment_id
  name                     = var.name
  kubernetes_version       = var.kubernetes_version
  control_plane_type       = "private"
  install_flannel          = false
  create_bastion           = false
  node_count               = var.node_count
  node_ocpus               = var.node_ocpus
  node_memory_gb           = var.node_memory_gb
  node_boot_volume_size_gb = var.node_boot_volume_size_gb
  node_data_volume_size_gb = var.node_data_volume_size_gb
  pods_cidr                = var.pods_cidr
  services_cidr            = var.services_cidr
  ssh_public_key           = var.ssh_public_key
  cloud_init_local = templatefile("${path.module}/cloud-init.sh", {
    auth_key             = tailscale_tailnet_key.node.key
    endpoint_subnet_cidr = "10.0.0.0/24"
  })

  extra_nodes_ingress_rules = [
    for port in var.exposed_ports : {
      source      = "0.0.0.0/0"
      protocol    = port.protocol
      tcp_options = port.protocol == "6" ? { min = port.min, max = port.max } : null
      udp_options = port.protocol == "17" ? { min = port.min, max = port.max } : null
    }
  ]
}

module "cilium" {
  source = "git::https://github.com/andrewzn69/tf-cilium.git?ref=v0.1.4"

  cilium_version   = var.cilium_version
  values_default   = "oke"
  cluster_endpoint = "https://${module.oke.cluster_endpoint}"
}
