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
  direct_cnames  = toset(["proxmox"])
  traefik_cnames = toset(["rss"])
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

resource "cloudflare_dns_record" "traefik_cname" {
  for_each = local.traefik_cnames

  zone_id = var.cloudflare_zone_id
  name    = each.key
  ttl     = 1
  type    = "CNAME"
  comment = "Traefik-routed CNAME for ${each.key}"
  content = "traefik.${var.tailscale_magic_dns_domain}"
  proxied = false
}
