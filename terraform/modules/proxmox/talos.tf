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
  # Creates a custom talos linux ISO for each VM
  # Assigns at static ip for each with kernel command line arguments
  for_each = local.vms
  schematic = yamlencode(
    {
      customization = {
        extraKernelArgs = [
          "ip=${each.value.ip_address}::${var.default_gateway}:255.255.255.0::eth0:none"
        ]
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.versions.extensions_info[*].name
        }
      }
    }
  )
}

data "talos_image_factory_urls" "this" {
  # Creates a URL for each custom ISO image for proxmox to download
  for_each = local.vms
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.schematic[each.key].id
  platform      = "nocloud"
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  for_each     = local.vms
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  file_name    = "talos-${var.talos_version}-${each.key}-nocloud-amd64.iso"
  url          = data.talos_image_factory_urls.this[each.key].urls.iso
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
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_image[each.key].id
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }
}