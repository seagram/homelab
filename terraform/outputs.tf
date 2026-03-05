output "tailscale_oauth_id" {
  value     = module.tailscale.tailscale_oauth_id
  sensitive = true
}

output "tailscale_oauth_key" {
  value     = module.tailscale.tailscale_oauth_key
  sensitive = true
}
