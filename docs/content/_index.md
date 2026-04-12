+++
title = "homelab"
sort_by = "weight"
+++

# homelab

A homelab for self-hosting open source software.

## Requirements

- 4+ CPU cores
- 16GB+ RAM
- 512GB+ storage
- [Proxmox VE](https://www.proxmox.com/en/proxmox-virtual-environment/overview) 9.1.6

> These figures can change depending on the number of services you run and which deployment target you choose.
> For reference, all deployment targets have been tested on a 2015 MacBook Pro with similar hardware specs as mentioned above.

## Installation

To start, clone the repository and `cd` into the homelab directory.
```sh
git clone https://github.com/seagram/homelab.git
cd homelab
```
Next, see [bootstrap](@/bootstrap/_index.md) for instructions on how to set up our homelab dependencies.
