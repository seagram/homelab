terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.85.0"
    }
  }
}

locals {
  ubuntu_vms = {
    control-plane = {
      vm_id      = 101
      cores      = 2
      memory     = 2048
    }
    worker-node-1 = {
      vm_id      = 102
      cores      = 1
      memory     = 1024
    }
    worker-node-2 = {
      vm_id      = 103
      cores      = 1
      memory     = 1024
    }
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu" {
  # Ubuntu 24.04 LTS
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  file_name = "noble-server-cloudimg-amd64.img"
  url = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  # cloud-config file used by cloud-init
  # automatically installs and deploys tailscale in each vm
  # no passwords/passkeys required; tailscale auth only
  content_type = "snippets"
  datastore_id = "local"
  node_name = "proxmox"

  source_raw {
    data = <<-EOF
    #cloud-config
    runcmd:
      - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
      - ['tailscale', 'up', '--auth-key=${var.tailscale_auth_key}']
      - ['tailscale', 'set', '--ssh']
    EOF
    file_name = "cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each = local.ubuntu_vms
  name            = each.key
  tags            = ["terraform"]
  vm_id           = each.value.vm_id
  node_name       = "proxmox"
  stop_on_destroy = true

  agent {
    enabled = true
    timeout = "5m"
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
    floating  = 0
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

  operating_system {
    type = "l26"
  }


  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

    user_account {
      username = "ubuntu"
      password = "password"
    }

    ip_config {
      ipv4 {
        address = "dhcp"
        gateway = "${var.default_gateway}"
      }
    }

    dns {
      servers = ["8.8.8.8", "8.8.4.4", "1.1.1.1"]
    }
  }
}