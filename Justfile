# ===========================================
# Variables
# ===========================================
compose_file := "docker/docker-compose.yml"
env_file := ".env"
dc := "docker compose -f " + compose_file + " --env-file " + env_file
homelab := dc + " run --rm homelab"
bash := homelab + " bash -c"
playbook := "ansible-playbook ansible/playbooks/site.yml"

# ===========================================
# Dependencies
# ===========================================

check-docker:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi
    if ! docker info &> /dev/null; then
        echo "Error: Docker daemon is not running"
        exit 1
    fi
    echo "✓ Docker is running"

check-env:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ ! -f .env ]; then
        echo "Error: .env file not found"
        echo "Run: cp .env.example .env"
        exit 1
    fi
    echo "✓ .env file found"

build: check-docker
    {{dc}} build homelab

shell: check-docker check-env build
    {{homelab}} bash

# ===========================================
# Ansible
# ===========================================

ansible-collections: check-docker check-env build
    {{bash}} "ansible-galaxy collection install -r ansible/requirements.yml"

ansible-ping: check-docker check-env build
    {{bash}} "ansible all -m ping"

ansible-configure: check-docker check-env build
    {{bash}} "{{playbook}} --limit proxmox-ssh --tags configure"

ansible-reverse-proxy: check-docker check-env build
    {{bash}} "{{playbook}} --limit proxmox-tailscale --tags reverse-proxy"

# ===========================================
# Other
# ===========================================

ssh:
    ssh root@proxmox

install-proxmox-usb:
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

help:
    @just --list

clean:
    {{dc}} down -v
    docker system prune -f