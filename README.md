<div align="center">

# homelab

A homelab for self-hosting open source software.

</div>

## Architecture

### Hardware

2015 MacBook Pro (4 CPU, 16GB RAM, r512GB SSD)

### Hypervisor

Proxmox VE 8.4

### Virtual machines

#### Talos Linux (v1.12) kubernetes cluster

| VM | Resources | Services |
|---|---|---|
| **control-plane** | 2 CPU, 2GB RAM, 20GB SSD | traefik, cert-manager, uptime-kuma |
| **worker-node-1** | 1 CPU, 1GB RAM, 20GB SSD | postgres, grafana, n8n |
| **worker-node-2** | 1 CPU, 1GB RAM, 20GB SSD | prometheus, loki, forgejo |

#### Standalone

| VM | Resources | OS |
|---|---|---|
| **nixos** | 1 CPU, 1GB RAM, 20GB SSD | NixOS v25.11 |
| **ubuntu** | 6 CPU, 12GB RAM, 50GB SDD | Ubuntu 24.04 LTS |
