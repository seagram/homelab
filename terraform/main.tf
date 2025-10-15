module "secrets" {
  source                = "./modules/secrets"
  tailscale_auth_key    = var.tailscale_auth_key
  root_password = var.root_password
  k3s_token = var.k3s_token
  tags                  = var.tags
}

module "cloudflare" {
  source                     = "./modules/cloudflare"
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
  cloudflare_zone_id         = var.cloudflare_zone_id
}

module "proxmox" {
  source         = "./modules/proxmox"
  root_password = var.root_password
}