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
    type = string
    default = "10.0.0.1"
}

variable "proxmox_ip" {
    type = string
    default = "10.0.0.10"
}

variable "control_plane_ip" {
    type = string
    default = "10.0.0.11"
}

variable "worker_node_1_ip" {
    type = string
    default = "10.0.0.12"
}

variable "worker_node_2_ip" {
    type = string
    default = "10.0.0.13"
}

#############################
#         tailscale         #
#############################

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "tailscale_api_token" {
  type = string
  sensitive = true
}

variable "tailscale_magic_dns_domain" {
  type = string
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

variable "root_password" {
  type        = string
  sensitive   = true
}

#############################
#         kubernetes        #
#############################

variable "enable_k3s" {
  type = bool
  default = false
}

variable "k3s_token" {
  type = string
  sensitive = true
}

variable "enable_kubernetes" {
  type = bool
  default = false
}

#############################
#           talos           #
#############################

variable "enable_talos" {
  type = bool
  default = true
}

variable "talos_version" {
  type = string
  default = "v1.11.3"
}