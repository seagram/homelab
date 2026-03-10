variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "http_ip" {
  type        = string
  description = "tailscale ip of machine running Packer"
  default = "100.93.89.78"
}
