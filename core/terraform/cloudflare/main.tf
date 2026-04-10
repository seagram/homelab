terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

locals {
  direct_cnames = toset([var.proxmox_subdomain])
}

resource "cloudflare_dns_record" "direct_cname" {
  for_each = local.direct_cnames

  zone_id = var.cloudflare_zone_id
  name    = each.key
  ttl     = 1
  type    = "CNAME"
  comment = "Direct CNAME for ${each.key}"
  content = "${each.key}.${var.tailscale_magic_dns_domain}"
  proxied = false
}
