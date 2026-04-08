module "tailscale" {
  source = "./tailscale"
}

module "cloudflare" {
  source                     = "../../../core/terraform/cloudflare"
  cloudflare_zone_id         = var.cloudflare_zone_id
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
}

module "proxmox" {
  depends_on            = [module.tailscale]
  source                = "./proxmox"
  default_gateway       = var.default_gateway
  control_plane_ip      = var.control_plane_ip
  worker_node_1_ip      = var.worker_node_1_ip
  worker_node_2_ip      = var.worker_node_2_ip
  talos_version         = var.talos_version
  tailscale_tailnet_key = module.tailscale.tailscale_tailnet_key
}

module "talos" {
  depends_on            = [module.proxmox]
  source                = "./talos"
  default_gateway       = var.default_gateway
  control_plane_ip      = var.control_plane_ip
  worker_node_1_ip      = var.worker_node_1_ip
  worker_node_2_ip      = var.worker_node_2_ip
  talos_version         = var.talos_version
  tailscale_tailnet_key = module.tailscale.tailscale_tailnet_key
  installer_image_url   = module.proxmox.installer_image_url
}
