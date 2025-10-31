variable "root_password" {
  type      = string
  sensitive = true
}

variable "default_gateway" {
  type = string
}

variable "proxmox_ip" {
  type = string
}

variable "vault_s3_bucket_name" {
  type    = string
  default = ""
}
