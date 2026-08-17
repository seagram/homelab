+++
title = "architecture"
weight = 3
+++

# Architecture

## Virtual Machines
A list of deployment targets using virtual machines running on the host OS.

| Name | Description |
|---|---|
| **ubuntu-docker** | 1 Ubuntu VM, running services with Docker |
| **ubuntu-k3s** | 3 Ubuntu VMs, running services with k3s (1 control-plane, 2 worker-node)|
| **talos** | 3 Talos Linux VMs, running services with Talos k8s cluster (1 control-plane, 2 worker-node)|
| **nixos** | 1 NixOS VM with `flake.nix` configuration |

## Containers
A list of containers running directly on the host OS, outside of a VM.

| Name | Description |
|---|---|
| **lxc** | Docker-in-LXC, running through `incus` |
