locals {
  proxmox_tailscale_ip = data.tailscale_device.proxmox.addresses[0]
  node_ips = {
    control-plane = {
      ip   = data.tailscale_device.control_plane.addresses[0]
    }
    worker-node-1 = {
      ip = data.tailscale_device.worker_node_1.addresses[0]
    }
    worker-node-2 = {
      ip = data.tailscale_device.worker_node_2.addresses[0]
    }
  }
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

resource "ansible_host" "tailscale_hosts" {
  for_each = local.node_ips
  name   = "${each.key}-tailscale"
  groups = ["tailscale"]
  variables = {
    ansible_host       = "${each.value.ip}"
    ansible_user       = "ubuntu"
    ansible_connection = "ssh"
  }
}