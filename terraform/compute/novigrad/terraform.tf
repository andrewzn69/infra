terraform {
  required_version = "~> 1.15"

  cloud {
    organization = "zemn"

    workspaces {
      name = "novigrad"
    }
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.6.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 8.14"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29"
    }
  }
}
