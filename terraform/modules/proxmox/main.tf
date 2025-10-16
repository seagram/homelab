terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}