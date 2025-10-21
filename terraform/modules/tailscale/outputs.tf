output "tailscale_oauth_id" {
    value = tailscale_oauth_client.client.id
    sensitive = true
}

output "tailscale_oauth_key" {
    value = tailscale_oauth_client.client.key
    sensitive = true
}

output "ips" {
    value = {
        proxmox_ip       = data.tailscale_device.proxmox.addresses[0]
        # control_plane_ip = data.tailscale_device.control_plane.addresses[0]
        # worker_node_1_ip = data.tailscale_device.worker_node_1.addresses[0]
        # worker_node_2_ip = data.tailscale_device.worker_node_2.addresses[0]
    }
}