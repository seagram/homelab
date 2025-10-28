resource "digitalocean_project" "homelab" {
  name        = "homelab"
  description = "resources for homelab"
}

resource "digitalocean_database_cluster" "postgres" {
  depends_on = [ digitalocean_project.homelab ]
  name       = "postgres"
  engine     = "pg"
  version    = "17"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  project_id = digitalocean_project.homelab.id
  node_count = 1
}

data "tailscale_devices" "all_devices" {}

resource "digitalocean_database_firewall" "postgres_firewall" {
  cluster_id = digitalocean_database_cluster.postgres.id

  dynamic "rule" {
    for_each = flatten([
      for device in data.tailscale_devices.all_devices.devices : device.addresses[0]
    ])
    content {
      type  = "ip_addr"
      value = rule.value
    }
  }
}