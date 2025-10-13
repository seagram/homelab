module "cloudflare" {
  source                     = "./modules/cloudflare"
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
  cloudflare_zone_id         = var.cloudflare_zone_id
}

module "proxmox" {
  source                   = "./modules/proxmox"
  proxmox_api_url          = var.proxmox_api_url
  proxmox_api_token_id     = var.proxmox_api_token_id
  proxmox_api_token_secret = var.proxmox_api_token_secret
  talos_version            = var.talos_version
  talos_nameserver         = var.talos_nameserver
}

module "secrets" {
  source                        = "./modules/secrets"
  tailscale_auth_key            = var.tailscale_auth_key
  tailscale_magic_dns_domain    = var.tailscale_magic_dns_domain
  cloudflare_provider_api_token = var.cloudflare_provider_api_token
  cloudflare_api_token          = var.cloudflare_api_token
  cloudflare_zone_id            = var.cloudflare_zone_id
  proxmox_api_token_id          = var.proxmox_api_token_id
  proxmox_api_token_secret      = var.proxmox_api_token_secret
  proxmox_root_password         = var.proxmox_root_password
  talos_nameserver              = var.talos_nameserver
  tags                          = var.tags
}