output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_region" {
  value = aws_s3_bucket.terraform_state.region
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "sops_kms_key_arn" {
  value = aws_kms_key.sops.arn
}

output "sops_kms_alias_arn" {
  description = "ARN of SOPS KMS alias used in .sops.yaml"
  value       = aws_kms_alias.sops.arn
}
