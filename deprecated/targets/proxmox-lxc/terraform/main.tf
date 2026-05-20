variable "gateway" {
  type        = string
  default     = "192.168.2.1"
}

locals {
  services = {
    caddy       = { memory = 256, disk = 4, ip = 101 }
    dockge      = { memory = 256, disk = 4, ip = 102 }
    forgejo     = { memory = 1024, disk = 20, ip = 103 }
    glance      = { memory = 256, disk = 4, ip = 104 }
    grafana     = { memory = 512, disk = 8, ip = 105 }
    loki        = { memory = 1024, disk = 20, ip = 106 }
    miniflux    = { memory = 512, disk = 4, ip = 107 }
    n8n         = { memory = 512, disk = 8, ip = 108 }
    nanoclaw    = { memory = 256, disk = 4, ip = 109 }
    postgres    = { memory = 1024, disk = 20, ip = 110 }
    prometheus  = { memory = 1024, disk = 20, ip = 111 }
    uptime-kuma = { memory = 512, disk = 8, ip = 112 }
  }
  # extract prefix address from the gateway to use as the subnet prefix for container IPs
  subnet_prefix = join(".", slice(split(".", var.gateway), 0, 3))
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory/hosts.yml"
  content = yamlencode({
    all = {
      hosts = {
        for name, svc in local.services : name => {
          ansible_host = "${local.subnet_prefix}.${svc.ip}"
          service_name = name
          memory       = svc.memory
          disk         = svc.disk
        }
      }
    }
  })
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
        address = "${local.subnet_prefix}.${each.value.ip}/24"
        gateway = var.gateway
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
