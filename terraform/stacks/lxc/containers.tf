locals {
  containers = {
    grafana = {
      memory = 512
      disk   = 8
      ref    = "docker.io/grafana/grafana:latest"
    }
    loki = {
      memory = 1024
      disk   = 20
      ref    = "docker.io/grafana/loki:latest"
    }
    prometheus = {
      memory = 1024
      disk   = 20
      ref    = "docker.io/prom/prometheus:latest"
    }
    traefik = {
      memory = 256
      disk   = 4
      ref    = "docker.io/library/traefik:latest"
    }
    uptime-kuma = {
      memory = 512
      disk   = 8
      ref    = "docker.io/louislam/uptime-kuma:latest"
    }
    forgejo = {
      memory = 1024
      disk   = 20
      ref    = "codeberg.org/forgejo/forgejo:14.0.3"
    }
    dokploy = {
      memory = 768
      disk   = 8
      ref    = "dokploy/dokploy:latest"
    }
    miniflux = {
      memory = 512
      disk   = 4
      ref    = "miniflux/miniflux:latest"
    }
    n8n = {
      memory = 768
      disk   = 8
      ref    = "n8nio/n8n:latest"
    }
    excalidraw = {
      memory = 512
      disk   = 4
      ref    = "excalidraw/excalidraw:latest"
    }
    postgres = {
      memory = 1024
      disk   = 20
      ref    = "docker.io/library/postgres:17-alpine"
    }
  }
}

resource "proxmox_virtual_environment_oci_image" "images" {
  for_each     = local.containers
  node_name    = "pve"
  datastore_id = "local"
  reference    = each.value.ref
}

resource "proxmox_virtual_environment_container" "containers" {
  for_each = local.containers

  node_name    = "pve"
  vm_id        = 101 + index(keys(local.containers), each.key) # auto-increment vm id
  description  = "managed by terraform"
  unprivileged = true
  started      = true
  start_on_boot = true

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
    template_file_id = proxmox_virtual_environment_oci_image.images[each.key].id
    type             = "unmanaged"
  }
}
