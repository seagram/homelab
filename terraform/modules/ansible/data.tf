data "tailscale_device" "proxmox" {
    hostname = "proxmox"
}

data "tailscale_device" "vault" {
    hostname = "vault"
}