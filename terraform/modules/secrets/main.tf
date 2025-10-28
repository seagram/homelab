terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

locals {
  secrets = {}
}

resource "aws_ssm_parameter" "secrets" {
  for_each = local.secrets
  name     = "/homelab/${each.key}"
  type     = "SecureString"
  value    = each.value
}