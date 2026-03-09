.PHONY: init build download-iso

init:
	packer init .

download-iso:
	# inline host trickery:
	# trailinig comma indicates host list instead of file path
	ansible-playbook -i "proxmox," download-iso.yml

build: init
	packer build .
