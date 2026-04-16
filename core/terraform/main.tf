terraform {
  backend "s3" {
    bucket = "homelab-terraform-state-bucket"
    key    = "core/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

locals {
  direct_cnames = toset([var.proxmox_hostname])
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
