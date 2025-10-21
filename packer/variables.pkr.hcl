variable "proxmox_url" {
    type = string
    default = "https://proxmox.javanese-octatonic.ts.net:8006/api2/json"
}

variable "proxmox_api_token" {
    type = string
    sensitive = true
}

variable "tailscale_auth_key" {
    type = string
    sensitive = true
}