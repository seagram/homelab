#############################
#          general          #
#############################

module "secrets" {
  source             = "./modules/secrets"
  tailscale_auth_key = var.tailscale_auth_key
  k3s_token          = var.k3s_token
}

module "cloudflare" {
  source                     = "./modules/cloudflare"
  cloudflare_zone_id         = var.cloudflare_zone_id
  tailscale_magic_dns_domain = var.tailscale_magic_dns_domain
}

module "tailscale" {
  source     = "./modules/tailscale"
}

#############################
#            k3s            #
#############################

module "proxmox-k3s" {
  count              = var.enable_k3s ? 1 : 0
  source             = "./modules/proxmox-k3s"
  default_gateway    = var.default_gateway
  tailscale_auth_key = var.tailscale_auth_key
}

module "ansible" {
  count = var.enable_ansible ? 1 : 0
  source             = "./modules/ansible"
  k3s_token          = var.k3s_token
  default_gateway    = var.default_gateway
  proxmox_ip         = var.proxmox_ip
  root_password      = var.root_password
  tailscale_auth_key = var.tailscale_auth_key
  depends_on         = [module.tailscale]
}

#############################
#           talos           #
#############################

module "proxmox-talos" {
  source           = "./modules/proxmox-talos"
  default_gateway  = var.default_gateway
  control_plane_ip = var.control_plane_ip
  worker_node_1_ip = var.worker_node_1_ip
  worker_node_2_ip = var.worker_node_2_ip
  talos_version    = var.talos_version
  depends_on       = [module.tailscale, module.secrets]
}

module "talos" {
  source             = "./modules/talos"
  default_gateway    = var.default_gateway
  control_plane_ip   = var.control_plane_ip
  worker_node_1_ip   = var.worker_node_1_ip
  worker_node_2_ip   = var.worker_node_2_ip
  talos_version      = var.talos_version
  tailscale_auth_key = var.tailscale_auth_key
  vm_triggers        = module.proxmox-talos.vm_ids
  installer_image_url = module.proxmox-talos.installer_image_url
  depends_on         = [module.proxmox-talos]
}

#############################
#         kubernetes        #
#############################


module "kubernetes" {
  count               = var.enable_kubernetes ? 1 : 0
  source              = "./modules/kubernetes"
  depends_on          = [module.ansible, module.tailscale]
}