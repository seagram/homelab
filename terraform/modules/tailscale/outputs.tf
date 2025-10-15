output "tailscale_oauth_id" {
    value = tailscale_oauth_client.client.id
    sensitive = true
}

output "tailscale_oauth_key" {
    value = tailscale_oauth_client.client.key
    sensitive = true
}