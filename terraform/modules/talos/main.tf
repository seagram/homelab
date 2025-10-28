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

resource "terraform_data" "vm_trigger" {
  for_each = {
    "control_plane" = "control-plane"
    "worker_1"      = "worker-node-1"
    "worker_2"      = "worker-node-2"
  }

  input = lookup(var.vm_triggers, each.value, "")
}

resource "talos_machine_configuration_apply" "this" {
  for_each = local.nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.value.ip
  timeouts = {
    create = "4m"
  }
  config_patches = [
    yamlencode({
      machine = {
        install = {
          disk  = "/dev/vda"
          image = var.installer_image_url
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = [
        "TS_AUTHKEY=${var.tailscale_tailnet_key}"
      ]
    })
  ]

  lifecycle {
    replace_triggered_by = [
      terraform_data.vm_trigger["control_plane"],
      terraform_data.vm_trigger["worker_1"],
      terraform_data.vm_trigger["worker_2"]
    ]
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on           = [talos_machine_configuration_apply.this]
  client_configuration = data.talos_client_configuration.this.client_configuration
  node                 = var.control_plane_ip
  timeouts = {
    create = "4m"
  }
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.control_plane_ip
}

resource "local_file" "kubeconfig" {
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = "${path.root}/../kubeconfig"
  file_permission = "0600"
}

resource "local_file" "talosconfig" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = "${path.root}/../talosconfig"
  file_permission = "0600"
}