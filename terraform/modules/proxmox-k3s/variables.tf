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

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}