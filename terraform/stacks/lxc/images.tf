locals {
  oci_images = {
    grafana = {
      ref = "docker.io/grafana/grafana:latest"
    }
    loki = {
      ref = "docker.io/grafana/loki:latest"
    }
    prometheus = {
      ref = "docker.io/prom/prometheus:latest"
    }
    traefik = {
      ref = "docker.io/library/traefik:latest"
    }
  }
}

resource "proxmox_virtual_environment_oci_image" "images" {
  for_each = local.oci_images
  node_name    = "pve"
  datastore_id = "local"
  reference    = each.value.ref
}
