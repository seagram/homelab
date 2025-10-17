variable "root_password" {
  type        = string
  sensitive   = true
}

variable "k3s_token" {
  type        = string
  sensitive   = true
}

variable "default_gateway" {
    type = string
}

variable "proxmox_ip" {
    type = string
}

variable "tailscale_ips" {
  type = any
}