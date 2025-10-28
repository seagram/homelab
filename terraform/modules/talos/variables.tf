variable "cluster_name" {
    type = string
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

variable "vm_triggers" {
  description = "VM IDs to trigger configuration reapplication when VMs change"
  type        = map(string)
  default     = {}
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