terraform {
  required_providers {
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.23.0"
    }
  }
}

resource "tailscale_tailnet_settings" "settings" {
   devices_auto_updates_on = true
   https_enabled = true
}

resource "tailscale_acl" "acl" {
  acl = jsonencode({
    "grants" : [
      {
        "src" : ["*"],
        "dst" : ["*"],
        "ip"  : ["*"]
      }
    ],
    "ssh" : [
      {
        "action" : "accept",
        "src"    : ["autogroup:member"],
        "dst"    : ["autogroup:self"],
        "users"  : ["autogroup:nonroot", "root"]
      }
    ],
    "tagOwners" : {
      "tag:k8s-operator" : [],
      "tag:k8s"          : ["tag:k8s-operator"]
    },
    "nodeAttrs" : [
      {
        "target" : ["tag:k8s"],
        "attr"   : ["funnel"]
      }
    ]
  })
  overwrite_existing_content = true
  reset_acl_on_destroy = true
}

resource "tailscale_oauth_client" "k8s_operator" {
  depends_on  = [tailscale_acl.acl]
  description = "k8s operator"
  scopes      = ["devices:core", "auth_keys"]
  tags        = ["tag:k8s-operator"]
}

output "k8s_operator_oauth_client_id" {
  value       = tailscale_oauth_client.k8s_operator.id
}

output "k8s_operator_oauth_client_secret" {
  value       = tailscale_oauth_client.k8s_operator.key
  sensitive   = true
}

resource "tailscale_tailnet_key" "tailnet_key" {
  depends_on = [ tailscale_acl.acl ]
  reusable      = true
  ephemeral     = true
  preauthorized = true
  description   = "Talos Linux Nodes"
  tags = ["tag:k8s"]
}