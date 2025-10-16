locals {
  talos_version = "v1.11.3"
  schematic_id = "7d4c31cbd96db9f90c874990697c523482b2bae27fb4631d5583dcd9c281b1ff"

  vms = {
    control-plane = {
      vm_id      = 101
      name       = "control-plane"
      ip_address = "${var.control_plane_ip}"
    }
    worker-node-1 = {
      vm_id      = 102
      name       = "worker-node-1"
      ip_address = "${var.worker_node_1_ip}"
    }
    worker-node-2 = {
      vm_id      = 103
      name       = "worker-node-2"
      ip_address = "${var.worker_node_2_ip}"
    }
  }
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  # Hardware Type: Cloud Server
  # System Extensions: [qemu-guest-agent, tailscale]
  content_type = "iso"
  datastore_id = "local"
  node_name = "proxmox"
  file_name = "talos-${local.talos_version}-nocloud-amd64.iso"
  url = "https://factory.talos.dev/image/${local.schematic_id}/${local.talos_version}/nocloud-amd64.iso"
  overwrite = false
}


resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each = local.vms
  name = each.value.name
  tags = ["terraform"]
  node_name = "proxmox"
  on_boot = true

  cpu {
    cores = 2
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
    dns {
      servers = ["8.8.8.8", "8.8.4.4"]
    }
  }
}