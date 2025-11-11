terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

locals {
  vms = merge(
    {
      control-plane = {
        vm_id      = 101
        name       = "control-plane"
        ip_address = "${var.control_plane_ip}"
        memory     = var.enable_worker_nodes ? 4096 : 12288
      }
    },
    var.enable_worker_nodes ? {
      worker-node-1 = {
        vm_id      = 102
        name       = "worker-node-1"
        ip_address = "${var.worker_node_1_ip}"
        memory     = 3072
      }
      worker-node-2 = {
        vm_id      = 103
        name       = "worker-node-2"
        ip_address = "${var.worker_node_2_ip}"
        memory     = 3072
      }
    } : {}
  )
}

data "talos_image_factory_extensions_versions" "versions" {
  talos_version = var.talos_version
  filters = {
    names = ["qemu-guest-agent", "tailscale", "iscsi-tools", "util-linux-tools"]
  }
}

resource "talos_image_factory_schematic" "schematic" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.versions.extensions_info[*].name
        }
      }
    }
  )
}

data "talos_image_factory_urls" "this" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.schematic.id
  platform      = "nocloud"
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  file_name    = "talos-${var.talos_version}-nocloud-amd64.iso"
  url          = data.talos_image_factory_urls.this.urls.iso

  overwrite           = false
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each = local.vms
  name = each.value.name
  vm_id = each.value.vm_id
  tags = ["terraform"]
  node_name = "proxmox"
  on_boot = true

  cpu {
    cores = var.enable_worker_nodes ? 2 : 6
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating = 0
  }

  agent {
    enabled = true
    trim = true
  }

  stop_on_destroy = true

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_image.id
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = "10.0.0.1"
      }
      ipv6 {
        address = "dhcp"
      }
    }
    dns {
      servers = ["8.8.8.8", "8.8.4.4", "1.1.1.1"]
    }
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    size         = var.enable_worker_nodes ? 50 : 300
  }
}