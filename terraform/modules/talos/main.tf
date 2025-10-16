terraform {
  required_providers {
    talos = {
      source = "siderolabs/talos"
      version = "0.9.0"
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
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.control_plane_ip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine_configuration_apply" "this" {
    client_configuration = talos_machine_secrets.this.client_configuration
    machine_configuration_input = data.talos_machine_configuration.this.machine_configuration
    node = "${var.control_plane_ip}"
    timeouts = {
      create = "30s"
    }
}

resource "talos_machine_bootstrap" "this" {
    depends_on = [ talos_machine_configuration_apply.this ]
    client_configuration = data.talos_client_configuration.this.client_configuration
    node = "${var.control_plane_ip}"
}