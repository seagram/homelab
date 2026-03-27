locals {
  linux_images = {
    debian = {
      version = "13"
      url     = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13"
    }
    nixos = {
      version = "25.11"
      url     = "https://channels.nixos.org/nixos-25.11/latest-nixos-minimal-x86_64-linux.iso"
    }
    ubuntu = {
      version = "24.04.4"
      url     = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    }
  }
  selected_image = local.linux_images[var.image_name]
}

resource "proxmox_virtual_environment_download_file" "linux_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve"
  url          = local.selected_image.url
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = "docker-vm"
  vm_id     = 101
  tags      = ["terraform"]
  node_name = "proxmox"
  on_boot   = true

  cpu {
    cores = 6
    type  = "x86-64-v2-AES"
  }

  memory {
    # enable ballooning by making dedicated & floating equal
    dedicated = 12288
    floating  = 12288
  }

  agent {
    enabled = true
    trim    = true
  }

  stop_on_destroy = true

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.linux_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 100
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.vm_ip}/24"
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
}
