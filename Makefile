include ansible/.env
export

.PHONY: check-dependencies create-proxmox-usb configure-proxmox-installation terraform-init configure-tailnet-for-k8s deploy-proxmox-vms boostrap-talos-linux-nodes deploy-k8s-services

TAILSCALE_OAUTH_CLIENT_ID = $(shell cd terraform && terraform output -raw tailscale_oauth_id)
TAILSCALE_OAUTH_CLIENT_SECRET = $(shell cd terraform && terraform output -raw tailscale_oauth_key)

# Intended to be executed in the order of declaration.

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh

configure-proxmox-installation:
	cd ansible && ansible-playbook site.yml

configure-tailnet-for-k8s:
	cd terraform && terraform init && terraform apply -target=module tailscale -auto-approve

deploy-proxmox-vms:
	cd terraform && terraform apply -target=module proxmox -auto-approve

boostrap-talos-linux-nodes:
	cd terraform && terraform apply -target=module talos -auto-approve

deploy-k8s-services:
	cd kubernetes && helmfile apply
