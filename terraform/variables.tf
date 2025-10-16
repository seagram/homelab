variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "tailscale_magic_dns_domain" {
  type = string
  default = "javanese-octatonic.ts.net"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}


variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "k3s_token" {
  type = string
  sensitive = true
}

variable "tailscale_api_token" {
  type = string
  sensitive = true
}

variable "default_gateway" {
    type = string
    default = "10.0.0.1"
}

variable "control_plane_ip" {
    type = string
    default = "10.0.0.11"
}

variable "worker_node_1_ip" {
    type = string
    default = "10.0.0.12"
}

variable "worker_node_2_ip" {
    type = string
    default = "10.0.0.13"
}