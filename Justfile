# ===========================================
# Variables
# ===========================================
env_file := ".env"
playbook := "cd ansible && ansible-playbook playbooks/site.yml"
kubeconfig := justfile_directory() + "/.kube/config"
export KUBECONFIG := kubeconfig

# ===========================================
# Dependencies
# ===========================================

check-dependencies:
    #!/usr/bin/env bash
    set -euo pipefail

    dependencies=("terraform" "ansible" "kubectl")
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
# Ansible
# ===========================================

ansible-collections:
    cd ansible && ansible-galaxy collection install -r requirements.yml

ansible-ping:
    cd ansible && ansible all -m ping -i inventory

ansible-configure:
    {{playbook}} --limit proxmox-ssh --tags configure

ansible-reverse-proxy:
    {{playbook}} --limit proxmox-tailscale --tags reverse-proxy

# ansible-k3s: check-ansible check-env
#     {{playbook}} --limit k3s --tags k3s

ansible-k3s:
    cd ansible && ansible-playbook playbooks/k3s.yml -i inventory/hosts.yml

ansible-k3s-upgrade:
    cd ansible && ansible-playbook k3s.orchestration.upgrade -i inventory/hosts.yml


# ===========================================
# kubectl
# ===========================================
get-pods:
    kubectl get pods

get-nodes:
    kubectl get nodes

# ===========================================
# Other
# ===========================================

ssh-proxmox:
    ssh root@proxmox
ssh-control-plane:
    ssh ubuntu@control-plane
ssh-worker-node-1:
    ssh ubuntu@worker-node-1
ssh-worker-node-2:
    ssh ubuntu@worker-node-2

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