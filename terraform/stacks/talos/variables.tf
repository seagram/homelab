#############################
#          general          #
#############################

variable "tags" {
  type    = map(string)
  default = {}
}

#############################
#         networking        #
#############################

variable "default_gateway" {
  type    = string
  default = "192.168.2.1"
}

variable "proxmox_ip" {
  type    = string
  default = "192.168.2.15"
}

variable "control_plane_ip" {
  type    = string
  default = "192.168.2.20"
}

variable "worker_node_1_ip" {
  type    = string
  default = "192.168.2.21"
}

variable "worker_node_2_ip" {
  type    = string
  default = "192.168.2.22"
}

variable "nixos_vm_ip" {
  type    = string
  default = "192.168.2.23"
}

#############################
#         tailscale         #
#############################

variable "tailscale_api_token" {
  type      = string
  sensitive = true
}

variable "tailscale_magic_dns_domain" {
  type    = string
  default = "javanese-octatonic.ts.net"
}

#############################
#        cloudflare         #
#############################

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

#############################
#          proxmox          #
#############################

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

#############################
#         kubernetes        #
#############################

variable "admin_password" {
  type      = string
  sensitive = true
}

#############################
#           talos           #
#############################

variable "talos_version" {
  type    = string
  default = "v1.12.4"
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.config/kube/config"
}

variable "talosconfig_path" {
  type    = string
  default = "~/.config/talos/config"
}

#############################
#           nixos           #
#############################

variable "nixos_version" {
  type    = string
  default = "25.11"
}
