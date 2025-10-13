terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

resource "cloudflare_dns_record" "proxmox" {
  zone_id = var.cloudflare_zone_id
  name    = "proxmox"
  ttl     = 1
  type    = "CNAME"
  comment = "proxmox dashboard via tailscale serve"
  content = "proxmox.${var.tailscale_magic_dns_domain}"
  proxied = false
}