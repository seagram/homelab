variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "talos_version" {
  type    = string
  default = "v1.11.2"
}

variable "talos_nameserver" {
  type = string
}