output "tailscale_oauth_id" {
    value = tailscale_oauth_client.client.id
    sensitive = true
}

output "tailscale_oauth_key" {
    value = tailscale_oauth_client.client.key
    sensitive = true
}

output "tailscale_tailnet_key" {
    value = tailscale_tailnet_key.tailnet_key.key
    sensitive = true
}