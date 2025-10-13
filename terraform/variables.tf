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

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_root_password" {
  type      = string
  sensitive = true
}

variable "talos_version" {
  type    = string
  default = "v1.11.2"
}

variable "talos_nameserver" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}