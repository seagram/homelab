# ===========================================
# Dependencies
# ===========================================

check-dependencies:
    #!/usr/bin/env bash
    set -euo pipefail

    dependencies=("terraform" "ansible" "kubectl" "talosctl")
    missing=()

    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
            echo "✗ $dep is not installed!"
        else
            echo "✓ $dep is installed"
        fi
    done

# ===========================================
# Other
# ===========================================

create-proxmox-usb:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f "proxmox.iso" ]; then
        echo "Downloading Proxmox ISO..."
        wget -O proxmox.iso https://enterprise.proxmox.com/iso/proxmox-ve_9.0-1.iso
    else
        echo "✓ proxmox.iso already exists"
    fi
    if [ ! -f "proxmox.dmg" ]; then
        echo "Converting ISO to DMG format..."
        hdiutil convert proxmox.iso -format UDRW -o proxmox.dmg
    else
        echo "✓ proxmox.dmg already exists"
    fi
    echo ""
    echo "Available external disks:"
    diskutil list | grep "external, physical" | awk '{print $1}'
    echo ""
    read -p "Enter USB disk number (e.g., 2 for /dev/disk2): " DISK_NUM
    echo "Unmounting /dev/disk${DISK_NUM}..."
    diskutil unmountDisk /dev/disk${DISK_NUM}
    echo "Flashing USB drive..."
    sudo dd if=proxmox.dmg of=/dev/rdisk${DISK_NUM} bs=1m
    echo ""
    echo "✓ Proxmox USB drive created successfully."

list:
    @just --list

# ===========================================
# Notes
# ===========================================
# This configuration uses snippets to bootstrap the k3s cluster.
# Snippets are not enabled by default in new Proxmox installations.
# You need to enable them in the 'Datacenter > Storage' section of the Proxmox GUI.