packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {
  proxmox_url              = "https://proxmox.javanese-octatonic.ts.net:8006/api2/json"
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  node                     = "proxmox"

  vm_id                = 9000 # convention for proxmox
  vm_name              = "ubuntu-template"
  template_description = "ubuntu 24.04 LTS w/cloud-init"

  boot_iso {
    iso_file = "local:iso/ubuntu-24.04.4-live-server-amd64.iso"
    unmount  = true
  }

  os       = "l26"
  cpu_type = "host"
  cores    = 2
  memory   = 2048
  sockets  = 1

  scsi_controller = "virtio-scsi-single"

  disks {
    type         = "scsi"
    disk_size    = "50G"
    storage_pool = "local-lvm"
  }

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  http_directory    = "http"
  http_bind_address = "0.0.0.0"
  http_ip           = var.http_ip

  boot_command = [
    # stop the GRUB autoboot timer
    "<spacebar><wait>",
    # edit the selected boot entry
    "e<wait>",
    # go to end of command line
    "<down><down><down><end>",
    # append the autoinstall directive & fetch config from packer's HTTP server
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    # boot with modified command
    "<f10>"
  ]
  boot_wait = "10s"

  ssh_username = "packer"
  ssh_password = "packer"
  ssh_timeout  = "30m"
}

variable "packages" {
  type = list(string)
  default = [
    "qemu-guest-agent",
    "cloud-init",
    "curl",
    "wget",
    "git",
    "vim",
    "htop",
    "tailscale",
    "docker"
  ]
}

build {
  sources = ["source.proxmox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ${join(" ", var.packages)}",
      "sudo systemctl enable qemu-guest-agent",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo rm -f /var/lib/dbus/machine-id",
      "sudo cloud-init clean",
    ]
  }
}
