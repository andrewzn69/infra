terraform {
  required_version = "~> 1.15"

  cloud {
    organization = "zemn"

    workspaces {
      name = "tailscale"
    }
  }

  required_providers {
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.29.0"
    }
  }
}
