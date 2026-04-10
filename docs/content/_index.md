---
title: "homelab"
---

# homelab

A homelab for self-hosting open source software.

## Requirements

- 4+ CPU cores
- 16GB+ RAM
- 512GB+ storage
- [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment/overview) 9.1.6

> These figures can change depending on the number of services you run and which deployment target you choose.
> For reference, all deployment targets have been tested on a 2015 MacBook Pro with similar hardware specs as mentioned above.

## Targets

The homelab supports multiple deployment targets under `targets/`. Each target is a different approach to running services on the same hardware.

| Target | Description |
|---|---|
| **proxmox-lxc** | Docker-in-LXC, running directly on Proxmox |
| **ubuntu-docker** | Single Ubuntu VM, running Docker |
| **ubuntu-k3s** | 3 Ubuntu VMs, running k3s |
| **talos** | Tri-node Talos Linux kubernetes cluster |
| **nixos** | Single NixOS VM with `flake.nix` configuration |
