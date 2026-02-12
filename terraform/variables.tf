#############################
#          general          #
#############################

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_aws" {
  type    = bool
  default = false
}

variable "enable_worker_nodes" {
  type    = bool
  default = false
}

#############################
#         networking        #
#############################

variable "default_gateway" {
  type    = string
  default = "10.0.0.1"
}

variable "proxmox_ip" {
  type    = string
  default = "10.0.0.10"
}

variable "control_plane_ip" {
  type    = string
  default = "10.0.0.11"
}

variable "worker_node_1_ip" {
  type    = string
  default = "10.0.0.12"
}

variable "worker_node_2_ip" {
  type    = string
  default = "10.0.0.13"
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
  default = "v1.11.3"
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.config/kube/config"
}

variable "talosconfig_path" {
  type    = string
  default = "~/.config/talos/config"
}
