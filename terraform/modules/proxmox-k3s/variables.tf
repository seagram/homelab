variable "default_gateway" {
    type = string
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}