#############################
#         kubernetes        #
#############################

module "tailscale" {
  source     = "./modules/tailscale"
}

module "proxmox" {
  source                 = "./modules/proxmox"
  default_gateway        = var.default_gateway
  control_plane_ip       = var.control_plane_ip
  worker_node_1_ip       = var.worker_node_1_ip
  worker_node_2_ip       = var.worker_node_2_ip
  talos_version          = var.talos_version
  tailscale_tailnet_key  = module.tailscale.tailscale_tailnet_key
  depends_on             = [module.tailscale]
}

module "talos" {
  source                = "./modules/talos"
  default_gateway       = var.default_gateway
  control_plane_ip      = var.control_plane_ip
  worker_node_1_ip      = var.worker_node_1_ip
  worker_node_2_ip      = var.worker_node_2_ip
  talos_version         = var.talos_version
  tailscale_tailnet_key = module.tailscale.tailscale_tailnet_key
  vm_triggers           = module.proxmox.vm_ids
  installer_image_url   = module.proxmox.installer_image_url
  depends_on            = [module.proxmox]
}

module "kubernetes" {
  source                         = "./modules/kubernetes"
  tailscale_oauth_client_id      = module.tailscale.k8s_operator_oauth_client_id
  tailscale_oauth_client_secret  = module.tailscale.k8s_operator_oauth_client_secret
  admin_password = var.admin_password
  depends_on                     = [module.talos]
}

#############################
#          general          #
#############################

module "secrets" {
  count = var.enable_secrets ? 1 : 0
  source             = "./modules/secrets"
}

module "cloudflare" {
  source                     = "./modules/cloudflare"
  cloudflare_zone_id         = var.cloudflare_zone_id
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
}

module "ansible" {
  count = var.enable_ansible ? 1 : 0
  source             = "./modules/ansible"
  k3s_token          = var.k3s_token
  default_gateway    = var.default_gateway
  proxmox_ip         = var.proxmox_ip
  root_password      = var.root_password
}