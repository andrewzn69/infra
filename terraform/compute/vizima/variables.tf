# cluster

variable "cluster_endpoint" {
  type        = string
  description = "Full URL of the Kubernetes API endpoint"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

# iso

variable "iso_datastore_id" {
  type        = string
  description = "Proxmox datastore to download the ISO int"
}

# network

variable "gateway_ip" {
  type        = string
  description = "Gateway IP for VM network config"
}

variable "node_subnet" {
  type        = string
  description = "Subnet CIDR for node network config"
}

# node pool

variable "control_plane_groups" {
  type = list(object({
    bridge            = string
    cloudinit_storage = string
    count             = number
    cpu               = number
    disk_size         = number
    ip_range_start    = number
    memory            = number
    name              = string
    node_name         = string
    storage           = string
    vm_id_start       = number
  }))
  description = "Control plane node groups"
}

variable "worker_groups" {
  type = list(object({
    bridge            = string
    cloudinit_storage = string
    count             = number
    cpu               = number
    data_disk_size    = optional(number)
    data_storage      = optional(string)
    disk_size         = number
    ip_range_start    = number
    memory            = number
    name              = string
    node_name         = string
    storage           = string
    vm_id_start       = number
  }))
  description = "Worker node groups"
}

# proxmox

variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint URL"
}

variable "proxmox_token_id" {
  type        = string
  description = "Proxmox API token ID"
  sensitive   = true
}

variable "proxmox_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

# talos

variable "install_disk" {
  type        = string
  description = "Disk path for Talos installation"
}

variable "schematic_extensions" {
  type        = list(string)
  description = "Talos image factory extensions"
  default     = []
}

# versions

variable "argocd_version" {
  type        = string
  description = "ArgoCD Helm chart version"
}

variable "cilium_version" {
  type        = string
  description = "Cilium Helm chart version"
}

variable "talos_version" {
  type        = string
  description = "Talos version"
}
