locals {
  secrets = {
    tailscale_auth_key     = var.tailscale_auth_key
    root_password  = var.root_password
    k3s_token = var.k3s_token
  }
}

resource "aws_ssm_parameter" "secrets" {
  for_each = local.secrets
  name     = "/homelab/${each.key}"
  type     = "SecureString"
  value    = each.value

  tags = var.tags
}