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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "talos_nameserver" {
  type        = string
  sensitive   = true
}
