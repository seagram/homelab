resource "aws_s3_bucket" "terraform_state" {
  bucket = "homelab-terraform-state-bucket"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "sops" {
  description             = "SOPS encryption key for homelab secrets"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name    = "homelab-sops"
    Purpose = "sops"
  }
}

resource "aws_kms_alias" "sops" {
  name          = "alias/homelab-sops"
  target_key_id = aws_kms_key.sops.key_id
}

resource "local_file" "sops_config" {
  filename        = "${path.module}/../../.sops.yaml"
  file_permission = "0644"
  content = yamlencode({
    creation_rules = [{
      path_regex = "(^|/)\\.secrets\\.ya?ml$"
      kms        = aws_kms_alias.sops.arn
    }]
  })
}
