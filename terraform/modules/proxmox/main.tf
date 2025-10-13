terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

locals {
  talos_gateway      = "10.0.0.1"
  talos_network_cidr = "24"

  talos_nodes = {
    control-plane = {
      name   = "talos-control-plane"
      vmid   = 100
      ip     = "10.0.0.11"
      role   = "controlplane"
      memory = 4096
      cores  = 2
    }
    worker-1 = {
      name   = "talos-worker-node-1"
      vmid   = 101
      ip     = "10.0.0.12"
      role   = "worker"
      memory = 4096
      cores  = 2
    }
    worker-2 = {
      name   = "talos-worker-node-2"
      vmid   = 102
      ip     = "10.0.0.13"
      role   = "worker"
      memory = 4096
      cores  = 2
    }
  }
}

resource "proxmox_vm_qemu" "talos_nodes" {
  for_each = local.talos_nodes

  name        = each.value.name
  target_node = "proxmox"
  vmid        = each.value.vmid
  memory      = each.value.memory

  cpu {
    cores = each.value.cores
    type  = "host"
  }

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "local:iso/talos-${var.talos_version}-nocloud-amd64.iso"
        }
      }
      ide3 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "40G"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0  = "ip=${each.value.ip}/${local.talos_network_cidr},gw=${local.talos_gateway}"
  nameserver = var.talos_nameserver

  agent = 0

  tags = each.value.role
}