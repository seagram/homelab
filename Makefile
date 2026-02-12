.PHONY: check-dependencies create-proxmox-usb

check-dependencies:
	./scripts/check-dependencies.sh

create-proxmox-usb:
	./scripts/create-proxmox-usb.sh
