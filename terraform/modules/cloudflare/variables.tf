variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "tailscale_magic_dns_domain" {
  type = string
  sensitive = true
}