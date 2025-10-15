terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
  }
}

locals {
  vms = {
    control-plane = {
      vm_id      = 101
      name       = "control-plane"
      ip_address = "10.0.0.11/24"
      tags       = ["terraform"]
      cores      = 2
      memory     = 4096
    }
    worker-node-1 = {
      vm_id      = 102
      name       = "worker-node-1"
      ip_address = "10.0.0.12/24"
      tags       = ["terraform"]
      cores      = 2
      memory     = 4096
    }
    worker-node-2 = {
      vm_id      = 103
      name       = "worker-node-2"
      ip_address = "10.0.0.13/24"
      tags       = ["terraform"]
      cores      = 2
      memory     = 4096
    }
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  file_name    = "jammy-server-cloudimg-amd64.img"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each = local.vms

  name            = each.value.name
  tags            = each.value.tags
  vm_id           = each.value.vm_id
  node_name       = "proxmox"
  stop_on_destroy = true

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.ubuntu.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = "10.0.0.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "8.8.4.4"]
    }

    user_account {
      username = "ubuntu"
      password = var.root_password
    }
  }
}