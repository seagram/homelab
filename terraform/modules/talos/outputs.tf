output "kubeconfig" {
  value       = local.kubeconfig_with_tailnet
  sensitive   = true
}

output "talosconfig" {
  value       = data.talos_client_configuration.tailnet.talos_config
  sensitive   = true
}
