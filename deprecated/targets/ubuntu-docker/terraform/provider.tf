terraform {
  backend "s3" {
    bucket = "homelab-terraform-state-bucket"
    key    = "docker-ubuntu/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
