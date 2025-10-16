data "talos_client_configuration" "client_config" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = [var.control_plane_ip]
}

data "talos_machine_configuration" "machine_config" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.control_plane_ip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}