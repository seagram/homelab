variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_node_name" {
  type = string
}

variable "tailnet_dns_name" {
  type = string
}

variable "proxmox_tailscale_ip" {
  type = string
}

locals {
  proxmox_endpoint = "https://${var.proxmox_node_name}.${var.tailnet_dns_name}:8006/api2/json"
}
