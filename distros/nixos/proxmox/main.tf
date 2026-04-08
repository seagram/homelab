terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
  }
}

locals {
  containers = {
    nixos = {
      vm_id      = 201
      hostname   = "nixos"
      ip_address = "${var.nixos_vm_ip}"
      memory     = 12288
      cores      = 2
      disk_size  = 150
    }
  }
}

resource "proxmox_virtual_environment_download_file" "nixos_lxc_template" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = "pve"
  url          = "https://hydra.nixos.org/build/325511670/download/1/nixos-image-lxc-proxmox-25.11pre-git-x86_64-linux.tar.xz"
  file_name    = "nixos-25.11.tar.xz"
}

resource "proxmox_virtual_environment_container" "container" {
  for_each      = local.containers
  vm_id         = each.value.vm_id
  tags          = ["terraform"]
  node_name     = "pve"
  start_on_boot = true
  started       = true
  unprivileged  = true

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk_size
  }

  network_interface {
    name     = "eth0"
    bridge   = "vmbr0"
    firewall = true
  }

  console {
    type = "console"
  }

  features {
    nesting = true
  }

  initialization {
    hostname = each.value.hostname

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

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.nixos_lxc_template.id
    type             = "unmanaged"
  }
}
