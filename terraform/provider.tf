terraform {
  backend "s3" {
    bucket="seagram-terraform-state-bucket"
    key="homelab/terraform.tfstate"
    region="us-east-1"
    use_lockfile = true
    encrypt      = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.22.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


provider "tailscale" {
  api_key = var.tailscale_api_token
}

provider "random" {}

provider "kubernetes" {
  config_path    = "../.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "../.kube/config"
  }
}

provider "proxmox" {
  endpoint  = "https://proxmox.${var.tailscale_magic_dns_domain}:8006/api2/json"
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    agent    = true
    username = "root"
    node {
      name    = "proxmox"
      address = data.tailscale_device.proxmox.addresses[0]
    }
  }
}