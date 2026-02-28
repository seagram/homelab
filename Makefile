include ansible/.env
export

.PHONY: check-dependencies create-proxmox-usb configure-proxmox-installation

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh

configure-proxmox-installation:
	cd ansible && ansible-playbook site.yml
