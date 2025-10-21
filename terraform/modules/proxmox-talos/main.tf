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

data "talos_image_factory_extensions_versions" "versions" {
  # Specifies which talos linux extensions to include within an ISO image
  talos_version = var.talos_version
  filters = {
    names = ["qemu-guest-agent", "tailscale"]
  }
}

resource "talos_image_factory_schematic" "schematic" {
  schematic = yamlencode(
    {
      customization = {
        # extraKernelArgs = [
        #   "ip=${each.value.ip_address}::${var.default_gateway}:255.255.255.0::eth0:none"
        # ]
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
  overwrite = true
  overwrite_unmanaged = true
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
    floating = 0
  }

  agent {
    enabled = true
    trim = true
  }

  stop_on_destroy = true

  network_device {
    bridge = "vmbr0"
    # model = "virtio"
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
        # address = "dhcp"
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
    iothread     = true
    discard      = "on"
    size         = 20
  }
}