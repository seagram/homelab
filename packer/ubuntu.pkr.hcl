packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {
  proxmox_url              = var.proxmox_url
  insecure_skip_tls_verify = true
  username                 = "root@pam"
  token                    = var.proxmox_api_token
  node                     = "proxmox"

  vm_name                  = "ubuntu-template"
  template_name            = "ubuntu-template"
  template_description     = "Ubuntu 24.04 LTS w/ qemu-guest-agent & tailscale"

  boot_iso {
    type             = "scsi"
    iso_url          = "https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso"
    iso_checksum     = "file:https://releases.ubuntu.com/24.04/SHA256SUMS"
    iso_download_pve = true
    iso_storage_pool = "local"
    unmount          = true
  }

  memory                   = 2048
  cores                    = 2
  cpu_type                 = "host"
  scsi_controller          = "virtio-scsi-single"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    type              = "scsi"
    disk_size         = "20G"
    storage_pool      = "local-lvm"
    format            = "raw"
    io_thread         = true
    discard           = true
  }

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  boot_command = [
    "<wait>c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
  boot_wait = "5s"

  http_content = {
    "/user-data" = <<-EOF
    #cloud-config
    autoinstall:
      version: 1
      locale: en_US
      keyboard:
        layout: us
      ssh:
        install-server: true
        allow-pw: true
      packages:
        - qemu-guest-agent
        - cloud-init
        - curl
      storage:
        layout:
          name: direct
      user-data:
        disable_root: false
        users:
          - name: ubuntu
            passwd: $6$rounds=4096$saltsalt$KlLdNSJjhQNlNXEWiRjk6b.LJrXZnT7Z5qZ9Qz1QZ7Z9QZ7Z9QZ7Z9QZ7Z9QZ7Z9QZ7Z9QZ7Z9QZ7Z9QZ7Z9Q0
            lock_passwd: false
            sudo: ALL=(ALL) NOPASSWD:ALL
            shell: /bin/bash
        chpasswd:
          expire: false
        runcmd:
          - systemctl enable qemu-guest-agent
          - systemctl start qemu-guest-agent
      late-commands:
        - echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/ubuntu
        - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/ubuntu
    EOF
    "/meta-data" = ""
  }

  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "20m"
}

build {
  sources = ["source.proxmox-iso.ubuntu"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "TAILSCALE_AUTH_KEY=${var.tailscale_auth_key}"
    ]
    inline = [
      "echo 'Installing tailscale...'",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "echo 'Authenticating with Tailscale...'",
      "sudo tailscale up --auth-key=$TAILSCALE_AUTH_KEY --ssh",
      "echo 'Verifying qemu-guest-agent is installed and running...'",
      "sudo systemctl status qemu-guest-agent --no-pager || echo 'qemu-guest-agent not running yet'"
    ]
  }

  # Cleanup before converting to template
  provisioner "shell" {
    inline = [
      "echo 'Cleaning up...'",
      "sudo apt-get clean",
      "sudo rm -f /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo rm -f /var/lib/dbus/machine-id",
      "sudo ln -s /etc/machine-id /var/lib/dbus/machine-id",
      "sudo cloud-init clean",
      "sudo rm -rf /var/lib/cloud/instances/*",
      "sudo sync"
    ]
  }
}