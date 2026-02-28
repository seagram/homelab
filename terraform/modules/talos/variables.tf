variable "cluster_name" {
  type    = string
  default = "homelab"
}

variable "default_gateway" {
  type = string
}

variable "control_plane_ip" {
  type = string
}

variable "worker_node_1_ip" {
  type = string
}

variable "worker_node_2_ip" {
  type = string
}

variable "talos_version" {
  type = string
}

variable "tailscale_tailnet_key" {
  description = "Tailscale tailnet authentication key for the extension service"
  type        = string
  sensitive   = true
}

variable "installer_image_url" {
  description = "Talos installer image URL from the image factory"
  type        = string
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.config/kube/config"
}

variable "talosconfig_path" {
  type    = string
  default = "~/.config/talos/config"
}
