variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}

variable "k3s_token" {
  type = string
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
