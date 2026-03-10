terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

locals {
  vms = {
    control-plane = {
      vm_id         = 101
      name          = "control-plane"
      ip_address    = "${var.control_plane_ip}"
      memory        = 4096
      cores         = 2
      disk_size     = 50
      iso           = "talos-${var.talos_version}-nocloud-amd64"
      agent_enabled = true
    }
    worker-node-1 = {
      vm_id         = 102
      name          = "worker-node-1"
      ip_address    = "${var.worker_node_1_ip}"
      memory        = 4096
      cores         = 2
      disk_size     = 50
      iso           = "talos-${var.talos_version}-nocloud-amd64"
      agent_enabled = true
    }
    worker-node-2 = {
      vm_id         = 103
      name          = "worker-node-2"
      ip_address    = "${var.worker_node_2_ip}"
      memory        = 4096
      cores         = 2
      disk_size     = 50
      iso           = "talos-${var.talos_version}-nocloud-amd64"
      agent_enabled = true
    }
    # nixos = {
    #   vm_id         = 104
    #   name          = "nixos"
    #   ip_address    = "${var.nixos_vm_ip}"
    #   memory        = 1024
    #   cores         = 1
    #   disk_size     = 20
    #   iso           = "nixos-${var.nixos_version}-minimal-x86_64"
    #   agent_enabled = false
    # }
  }
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

resource "proxmox_virtual_environment_vm" "virtual_machines" {
  for_each  = local.vms
  vm_id     = each.value.vm_id
  name      = each.value.name
  tags      = ["terraform"]
  node_name = "proxmox"
  on_boot   = true

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = 0
  }

  agent {
    enabled = each.value.agent_enabled
    trim    = each.value.agent_enabled
  }

  stop_on_destroy = true

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  cdrom {
    file_id = "local:iso/${each.value.iso}.iso"
  }

  initialization {
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
      servers = ["8.8.8.8", "8.8.4.4", "1.1.1.1"]
    }
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    size         = each.value.disk_size
  }
}
