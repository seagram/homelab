variable "default_gateway" {
  type = string
}

variable "nixos_vm_ip" {
  type = string
}

variable "tailscale_tailnet_key" {
  type      = string
  sensitive = true
}

