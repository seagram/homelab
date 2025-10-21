locals {
  proxmox_tailscale_ip = data.tailscale_device.proxmox.addresses[0]
  # node_ips = {
  #   control-plane = {
  #     ip   = data.tailscale_device.control_plane.addresses[0]
  #   }
  #   worker-node-1 = {
  #     ip = data.tailscale_device.worker_node_1.addresses[0]
  #   }
  #   worker-node-2 = {
  #     ip = data.tailscale_device.worker_node_2.addresses[0]
  #   }
  # }
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



# resource "ansible_host" "tailscale_hosts" {
#   for_each = local.node_ips
#   name   = "${each.key}-tailscale"
#   groups = ["tailscale"]
#   variables = {
#     ansible_host       = "${each.value.ip}"
#     ansible_user       = "ubuntu"
#     ansible_connection = "ssh"
#   }
# }

#############################
#            k3s            #
#############################

# resource "ansible_host" "k3s_server" {
#   name   = "100.88.162.100"
#   groups = ["server", "k3s_cluster"]
#   variables = {
#     ansible_port = 22
#     ansible_user = "ubuntu"
#     k3s_version  = "v1.34.1+k3s1"
#     token        = var.k3s_token
#     api_endpoint = "100.88.162.100"
#     api_port     = 6443
#   }
# }

# resource "ansible_host" "k3s_agent_1" {
#   name   = "100.68.97.68"
#   groups = ["agent", "k3s_cluster"]
#   variables = {
#     ansible_port = 22
#     ansible_user = "ubuntu"
#     k3s_version  = "v1.34.1+k3s1"
#     token        = var.k3s_token
#     api_endpoint = "100.88.162.100"
#     api_port     = 6443
#   }
# }

# resource "ansible_host" "k3s_agent_2" {
#   name   = "100.116.205.52"
#   groups = ["agent", "k3s_cluster"]
#   variables = {
#     ansible_port = 22
#     ansible_user = "ubuntu"
#     k3s_version  = "v1.34.1+k3s1"
#     token        = var.k3s_token
#     api_endpoint = "100.88.162.100"
#     api_port     = 6443
#   }
# }