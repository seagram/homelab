terraform {
  backend "local" {}
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.99.0"
    }
  }
}

provider "proxmox" {
  endpoint  = local.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "root"
    node {
      name    = var.proxmox_node_name
      address = var.proxmox_tailscale_ip
    }
  }
}
