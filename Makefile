include ansible/.env
export

.PHONY: check-dependencies create-proxmox-usb configure-proxmox-installation terraform-init configure-tailnet-for-k8s deploy-proxmox-vms boostrap-talos-linux-nodes deploy-tailscale-operator deploy-longhorn deploy-prometheus deploy-prometheus

# Intended to be executed in the order of declaration.

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh

configure-proxmox-installation:
	cd ansible && ansible-playbook site.yml

terraform-init:
	cd terraform && terraform init

configure-tailnet-for-k8s:
	cd terraform && terraform apply -target=module tailscale -auto-approve

deploy-proxmox-vms:
	cd terraform && terraform apply -target=module proxmox -auto-approve

boostrap-talos-linux-nodes:
	cd terraform && terraform apply -target=module talos -auto-approve

deploy-tailscale-operator:
	./scripts/deploy-tailscale-operator.sh

deploy-longhorn:
	cd kubernetes/longhorn && helmfile apply
	kubectl apply -f kubernetes/longhorn/ingress.yaml

deploy-prometheus:
	cd kubernetes/prometheus && helmfile apply
	kubectl apply -f kubernetes/prometheus/ingress.yaml
