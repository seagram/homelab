resource "cloudflare_dns_record" "service" {
  for_each = var.service_subdomains

  zone_id = var.cloudflare_zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = 1
  comment = "Docker service ${each.value} fronted by Caddy on the tailnet"
  content = var.caddy_tailscale_fqdn
  proxied = false
}
