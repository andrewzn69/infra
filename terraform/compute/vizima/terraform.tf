terraform {
  required_version = "~> 1.15"

  cloud {
    organization = "zemn"

    workspaces {
      name = "vizima"
    }
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.106.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.11.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29"
    }
  }
}
