data "tailscale_device" "proxmox" {
    hostname = "proxmox"
}

data "tailscale_device" "control_plane" {
    hostname = "control-plane"
}

data "tailscale_device" "worker_node_1" {
    hostname = "worker-node-1"
}

data "tailscale_device" "worker_node_2" {
    hostname = "worker-node-2"
}