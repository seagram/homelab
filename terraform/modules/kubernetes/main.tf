terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.68.0"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.23.0"
    }
    grafana = {
      source = "grafana/grafana"
      version = "4.12.0"
    }
  }
}