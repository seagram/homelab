output "vm_ids" {
  value = {
    for key, vm in proxmox_virtual_environment_vm.virtual_machines : key => vm.id
  }
}

output "installer_image_url" {
  value       = data.talos_image_factory_urls.this.urls.installer
}
