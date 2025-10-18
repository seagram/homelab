locals {
    playbooks = {
        install_tailscale = {
            enabled = false
            playbook_file = "install_tailscale.yml"
            target_host = "proxmox-ssh"
            extra_vars = { tailscale_auth_key = var.tailscale_auth_key }
            replayable = false
        }
        disable_power_off = {
            enabled = false
            playbook_file = "disable_power_off.yml"
            target_host = "proxmox-tailscale"
            extra_vars = {}
            replayable = false
        }
        disable_password_authentication = {
            enabled = false
            playbook_file = "disable_password_auth.yml"
            target_host = "proxmox-tailscale"
            extra_vars = {}
            replayable = false
        }
        update_apt = {
            enabled = false
            playbook_file = "update_apt.yml"
            target_host = "proxmox-tailscale"
            extra_vars = {}
            replayable = false
        }
    }
}

resource "ansible_playbook" "playbooks" {
    for_each = { for k, v in local.playbooks : k => v if v.enabled }

    playbook   = "./playbooks/${each.value.playbook_file}"
    name       = each.value.target_host
    extra_vars = each.value.extra_vars
    replayable = each.value.replayable
}