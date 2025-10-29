locals {
  proxmox_tailscale_ip = data.tailscale_device.proxmox.addresses[0]
}

#############################
#            ssh            #
#############################

resource "ansible_host" "proxmox-ssh" {
  name   = "proxmox-ssh"
  groups = ["ssh"]
  variables = {
    ansible_host       = "${var.proxmox_ip}"
    ansible_user       = "root"
    ansible_connection = "ssh"
    ansible_ssh_pass   = var.root_password
  }
}

#############################
#         tailscale         #
#############################

resource "ansible_host" "proxmox_tailscale" {
  name   = "proxmox-tailscale"
  groups = ["tailscale"]
  variables = {
    ansible_host       = "${local.proxmox_tailscale_ip}"
    ansible_connection = "ssh"
  }
}