terraform {
  backend "local" {}
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://pve.javanese-octatonic.ts.net:8006/api2/json"
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "root"
    node {
      name    = "pve"
      address = "100.85.178.8"
    }
  }
}
