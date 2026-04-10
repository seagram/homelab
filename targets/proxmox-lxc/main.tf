locals {
  services = {
    caddy       = { memory = 256, disk = 4 }
    dockge      = { memory = 256, disk = 4 }
    forgejo     = { memory = 1024, disk = 20 }
    glance      = { memory = 256, disk = 4 }
    grafana     = { memory = 512, disk = 8 }
    loki        = { memory = 1024, disk = 20 }
    miniflux    = { memory = 512, disk = 4 }
    n8n         = { memory = 512, disk = 8 }
    nanoclaw    = { memory = 256, disk = 4 }
    postgres    = { memory = 1024, disk = 20 }
    prometheus  = { memory = 1024, disk = 20 }
    uptime-kuma = { memory = 512, disk = 8 }
  }
}

resource "proxmox_virtual_environment_download_file" "debian" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = "pve"
  url = "http://download.proxmox.com/images/system/debian-13-standard_13.1-2_amd64.tar.zst"
}

resource "proxmox_virtual_environment_container" "services" {
  for_each = local.services

  node_name     = "pve"
  vm_id         = 101 + index(keys(local.services), each.key)
  description   = "managed by terraform"
  unprivileged  = false
  started       = true
  start_on_boot = true

  initialization {
    hostname = each.key

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  cpu {
    cores = 1
  }

  features {
    nesting = true
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_download_file.debian.id
    type             = "debian"
  }
}
