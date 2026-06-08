terraform {
  required_version = "~> 1.15"

  cloud {
    organization = "zemn"

    workspaces {
      name = "infisical"
    }
  }

  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16.0"
    }
  }
}
