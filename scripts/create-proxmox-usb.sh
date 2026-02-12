#!/usr/bin/env bash
set -euo pipefail
echo "Downloading Proxmox ISO..."
curl -Lo proxmox.iso https://enterprise.proxmox.com/iso/proxmox-ve_9.1-1.iso
echo "Converting ISO to DMG format..."
hdiutil convert proxmox.iso -format UDRW -o proxmox.dmg
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
