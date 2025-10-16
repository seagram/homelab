module "tailscale" {
  source = "./modules/tailscale"
}

module "secrets" {
  source                = "./modules/secrets"
  tailscale_auth_key    = var.tailscale_auth_key
  k3s_token = var.k3s_token
}

module "cloudflare" {
  source             = "./modules/cloudflare"
  cloudflare_zone_id = var.cloudflare_zone_id
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
}

module "proxmox" {
  source         = "./modules/proxmox"
  default_gateway = var.default_gateway
  control_plane_ip = var.control_plane_ip
  worker_node_1_ip = var.worker_node_1_ip
  worker_node_2_ip = var.worker_node_2_ip
  talos_version = var.talos_version
  depends_on = [ module.tailscale, module.secrets ]
}

module "talos" {
  source = "./modules/talos"
  default_gateway = var.default_gateway
  control_plane_ip = var.control_plane_ip
  worker_node_1_ip = var.worker_node_1_ip
  worker_node_2_ip = var.worker_node_2_ip
  talos_version = var.talos_version
  depends_on = [ module.proxmox ]
}