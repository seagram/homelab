output "r2_bucket_name" {
  value       = cloudflare_r2_bucket.terraform_state.name
}

output "r2_account_id" {
  value       = var.cloudflare_account_id
  sensitive   = true
}

output "r2_s3_endpoint" {
  value       = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
}
