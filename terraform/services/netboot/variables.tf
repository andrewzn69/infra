# container

variable "hostname" {
  type        = string
  description = "Hostname for the netboot.xyz container"
  default     = "netboot"
}

variable "node_name" {
  type        = string
  description = "Proxmox node to create the container on"
}

variable "vm_id" {
  type        = number
  description = "Container ID"
}

# disk

variable "datastore_id" {
  type        = string
  description = "Proxmox storage pool for the container root filesystem"
  default     = "local-lvm"
}

variable "disk_size" {
  type        = number
  description = "Root filesystem size in GB"
  default     = 8
}

# network

variable "gateway_ip" {
  type        = string
  description = "IPv4 gateway"
}

variable "ip_address" {
  type        = string
  description = "IPv4 address in CIDR notation"
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

# template

variable "template_datastore_id" {
  type        = string
  description = "Proxmox datastore to download the container template into"
  default     = "local"
}

variable "template_url" {
  type        = string
  description = "URL of the LXC container template to download"
}

# user

variable "ssh_keys" {
  type        = list(string)
  description = "SSH public keys for the root account"
  default     = []
}
