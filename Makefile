include ansible/.env
export

.PHONY: check-dependencies create-proxmox-usb configure-proxmox-installation create-r2-tfstate-bucket

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh

configure-proxmox-installation:
	cd ansible && ansible-playbook site.yml

create-r2-tfstate-bucket:
	wrangler r2 bucket create terraform-state
