include ansible/.env
export

.PHONY: check-dependencies create-proxmox-usb bootstrap-baremetal

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh

bootstrap-baremetal:
	cd ansible && ansible-playbook site.yml
