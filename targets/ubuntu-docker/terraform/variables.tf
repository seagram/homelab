variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "caddy_tailscale_fqdn" {
  type = string
}

variable "service_subdomains" {
  type = set(string)
  default = [
    "glance",
    "grafana",
    "forgejo",
    "n8n",
    "status",
    "portainer",
    "logs",
  ]
}
