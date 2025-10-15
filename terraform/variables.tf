variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "tailscale_magic_dns_domain" {
  type      = string
  sensitive = true
}

variable "cloudflare_provider_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "proxmox_endpoint" {
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

variable "root_password" {
  type      = string
  sensitive = true
}