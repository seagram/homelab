terraform {
  required_providers {
    tailscale = {
      source = "tailscale/tailscale"
      version = "0.22.0"
    }
  }
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
        "action" : "check",
        "src"    : ["autogroup:member"],
        "dst"    : ["autogroup:self"],
        "users"  : ["autogroup:nonroot", "root"]
      }
    ],
    "tagOwners" : {
      "tag:k8s-operator" : [],
      "tag:k8s"          : ["tag:k8s-operator"]
    }
  })
  overwrite_existing_content = true
  reset_acl_on_destroy = true
}

resource "tailscale_oauth_client" "client" {
  depends_on = [ tailscale_acl.acl ]
  description = "k8s client"
  scopes      = ["devices:core", "auth_keys"]
  tags        = ["tag:k8s-operator"]
}