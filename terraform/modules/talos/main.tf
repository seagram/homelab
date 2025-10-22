terraform {
  required_providers {
    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

locals {
  nodes = {
    control_plane = {
      ip           = var.control_plane_ip
      machine_type = "controlplane"
    }
    worker_1 = {
      ip           = var.worker_node_1_ip
      machine_type = "worker"
    }
    worker_2 = {
      ip           = var.worker_node_2_ip
      machine_type = "worker"
    }
  }
}

resource "talos_machine_secrets" "this" {
    talos_version = var.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [var.control_plane_ip]
}

data "talos_machine_configuration" "this" {
  for_each = local.nodes

  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.control_plane_ip}:6443"
  machine_type     = each.value.machine_type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine_configuration_apply" "this" {
  for_each = local.nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.ip
  timeouts = {
    create = "2m"
  }
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda"
          image = "factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.9.5"
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.this]
  client_configuration = data.talos_client_configuration.this.client_configuration
  node                 = var.control_plane_ip
  timeouts = {
    create = "2m"
  }
}