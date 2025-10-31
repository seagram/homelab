data "tailscale_device" "proxmox" {
  hostname = "proxmox"
  wait_for = "120s"
}

data "tailscale_device" "vault" {
  hostname = "vault"
  wait_for = "120s"
}

locals {
  proxmox_tailscale_ip = data.tailscale_device.proxmox.addresses[0]
  vault_tailscale_ip   = data.tailscale_device.vault.addresses[0]
}

#############################
#          proxmox          #
#############################

resource "ansible_host" "proxmox_ssh" {
  name = "proxmox-ssh"
  variables = {
    ansible_host       = "${var.proxmox_ip}"
    ansible_user       = "root"
    ansible_connection = "ssh"
    ansible_ssh_pass   = var.root_password
  }
}

resource "ansible_host" "proxmox_tailscale" {
  name = "proxmox-tailscale"
  variables = {
    ansible_host     = "proxmox"
    ansible_ssh_user = "root"
  }
}

#############################
#           vault           #
#############################

resource "ansible_host" "vault_tailscale" {
  name = "vault-tailscale"
  variables = {
    ansible_host     = "vault"
    ansible_ssh_user = "ubuntu"
  }
}
