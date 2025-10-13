locals {
  secrets = {
    tailscale_auth_key            = var.tailscale_auth_key
    tailscale_magic_dns_domain    = var.tailscale_magic_dns_domain
    cloudflare_provider_api_token = var.cloudflare_provider_api_token
    cloudflare_api_token          = var.cloudflare_api_token
    cloudflare_zone_id            = var.cloudflare_zone_id
    proxmox_api_token_id          = var.proxmox_api_token_id
    proxmox_api_token_secret      = var.proxmox_api_token_secret
    proxmox_root_password         = var.proxmox_root_password
    talos_nameserver              = var.talos_nameserver
  }
}

resource "aws_ssm_parameter" "secrets" {
  for_each = local.secrets
  name     = "/homelab/${each.key}"
  type     = "SecureString"
  value    = each.value

  tags = var.tags
}