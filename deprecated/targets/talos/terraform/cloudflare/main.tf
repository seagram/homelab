terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

locals {
  service_hostnames = toset([
    "longhorn",
    "grafana",
    "prometheus",
    "loki",
    "traefik",
  ])
}

resource "cloudflare_dns_record" "service" {
  for_each = local.service_hostnames

  zone_id = var.cloudflare_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 1
  comment = "k8s service ${each.key} fronted by traefik on the tailnet"
  content = "traefik.${var.tailscale_magic_dns_domain}"
  proxied = false
}
