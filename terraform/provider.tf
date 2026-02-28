terraform {
  backend "local" {}
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.23.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "tailscale" {
  api_key = var.tailscale_api_token
}

provider "random" {}

provider "proxmox" {
  endpoint  = "https://proxmox.javanese-octatonic.ts.net:8006/api2/json"
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "root"
    node {
      name    = "proxmox"
      address = "100.85.178.8"
    }
  }
}
