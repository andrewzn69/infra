module "talos_schematic" {
  source = "git::https://github.com/andrewzn69/tf-talos-schematic.git?ref=v0.1.2"

  architecture         = "amd64"
  secureboot           = false
  talos_version        = var.talos_version
  schematic_extensions = var.schematic_extensions
  bootloader           = null
  extra_kernel_args    = []
  platform             = null
  sbc                  = null
}

module "proxmox_k8s_cluster" {
  source = "git::https://github.com/andrewzn69/tf-proxmox-k8s-cluster.git?ref=v0.1.2"

  iso_url              = module.talos_schematic.iso_url
  iso_datastore_id     = var.iso_datastore_id
  gateway_ip           = var.gateway_ip
  node_subnet          = var.node_subnet
  control_plane_groups = var.control_plane_groups
  worker_groups        = var.worker_groups
}

module "talos_cluster" {
  source = "git::https://github.com/andrewzn69/tf-talos-cluster.git?ref=v0.1.2"

  cluster_endpoint            = local.cluster_endpoint
  cluster_name                = var.cluster_name
  control_plane_ips           = module.proxmox_k8s_cluster.control_plane_ips
  worker_ips                  = module.proxmox_k8s_cluster.worker_ips
  node_subnet                 = var.node_subnet
  installer_image             = module.talos_schematic.installer_image
  talos_version               = var.talos_version
  install_disk                = var.install_disk
  extra_control_plane_patches = [file("${path.module}/patches/controlplane.yaml")]
  extra_worker_patches        = [file("${path.module}/patches/worker.yaml")]
}

module "cilium" {
  source = "git::https://github.com/andrewzn69/tf-cilium.git?ref=v0.1.4"

  cilium_version = var.cilium_version
  values_default = "talos"
}

module "argocd" {
  source = "git::https://github.com/andrewzn69/tf-argocd.git?ref=v0.1.2"

  argocd_version = var.argocd_version
}
