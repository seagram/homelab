terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.23.0"
    }
  }
}

locals {
  cnames = toset(["proxmox", "rss"])
}

resource "cloudflare_dns_record" "cname" {
  for_each = local.cnames

  zone_id = var.cloudflare_zone_id
  name    = each.key
  ttl     = 1
  type    = "CNAME"
  comment = "CNAME for ${each.key}"
  content = "${each.key}.${var.tailscale_magic_dns_domain}"
  proxied = false
}