# cilium

variable "cilium_version" {
  type        = string
  description = "Cilium Helm chart version"
}

# cluster

variable "compartment_id" {
  type        = string
  description = "OCID of the OCI compartment"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version in vX.Y.Z format"
}

variable "name" {
  type        = string
  description = "Cluster name - max 15 lowercase alphanumeric characters"
}

# network

variable "pods_cidr" {
  type        = string
  description = "Pod network CIDR"
}

variable "services_cidr" {
  type        = string
  description = "Service network CIDR"
}

# node pool

variable "node_boot_volume_size_gb" {
  type        = number
  description = "Boot volume size in GB per worker node"
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes"
}

variable "node_data_volume_size_gb" {
  type        = number
  description = "Data volume size in GB per worker node"
}

variable "node_memory_gb" {
  type        = number
  description = "Memory in GB per worker node"
}

variable "node_ocpus" {
  type        = number
  description = "OCPUs per worker node"
}

# oci credentials

variable "fingerprint" {
  type        = string
  description = "OCI API key fingerprint"
  sensitive   = true
}

variable "private_key" {
  type        = string
  description = "OCI API private key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "OCI region"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCI tenancy OCID"
  sensitive   = true
}

variable "user_ocid" {
  type        = string
  description = "OCI user OCID"
  sensitive   = true
}

# ports

variable "exposed_ports" {
  type = list(object({
    protocol = string
    min      = number
    max      = number
  }))
  description = "Ports to open on the endpoint subnet security list. protocol: 6 = TCP, 17 = UDP"
}

# ssh

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for node access"
}

# tailscale

variable "tailnet" {
  type        = string
  description = "Tailscale tailnet name"
}

variable "tailscale_oauth_client_id" {
  type        = string
  description = "Tailscale OAuth client ID"
  sensitive   = true
}

variable "tailscale_oauth_client_secret" {
  type        = string
  description = "Tailscale OAuth client secret"
  sensitive   = true
}
