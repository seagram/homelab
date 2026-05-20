terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
