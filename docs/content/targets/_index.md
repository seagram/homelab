+++
title = "targets"
weight = 3
+++

# targets

Deployment targets for running services on the homelab.

| Target | Description |
|---|---|
| **proxmox-lxc** | Docker-in-LXC, running directly on Proxmox |
| **ubuntu-docker** | Single Ubuntu VM, running Docker |
| **ubuntu-k3s** | 3 Ubuntu VMs, running k3s |
| **talos** | Tri-node Talos Linux kubernetes cluster |
| **nixos** | Single NixOS VM with `flake.nix` configuration |
