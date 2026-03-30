<div align="center">

# homelab

A homelab for self-hosting open source software.

</div>

## Architecture

### Hardware

2015 MacBook Pro (4 CPU, 16GB RAM, 512GB SSD)

### Hypervisor

Proxmox VE 9.1.6

### Virtual machines

#### Talos Linux (v1.12) kubernetes cluster

| VM | Resources | Services |
|---|---|---|
| **control-plane** | 2 CPU, 4GB RAM, 50GB SSD | traefik, cert-manager, uptime-kuma |
| **worker-node-1** | 2 CPU, 4GB RAM, 50GB SSD | postgres, grafana, n8n |
| **worker-node-2** | 2 CPU, 4GB RAM, 50GB SSD | prometheus, loki, forgejo |
