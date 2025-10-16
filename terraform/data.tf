data "tailscale_device" "proxmox" {
    hostname = "proxmox"
    wait_for = "60s"
}

data "tailscale_device" "control_plane" {
    hostname = "control-plane"
    wait_for = "60s"
}

data "tailscale_device" "worker-node-1" {
    hostname = "worker-node-1"
    wait_for = "60s"
}

data "tailscale_device" "worker-node-2" {
    hostname = "worker-node-2"
    wait_for = "60s"
}