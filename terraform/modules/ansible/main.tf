terraform {
  required_providers {
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.23.0"
    }
  }
}