terraform {
  required_version = "~> 1.15"

  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.5.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.106.0"
    }
  }
}
