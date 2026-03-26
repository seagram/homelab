locals {
  containers = {
    grafana = {
      description = "managed by terraform"
      node_name = "grafana"
      vm_id = 101
    }
  }
}

resource "proxmox_virtual_environment_container" "containers" {

}
