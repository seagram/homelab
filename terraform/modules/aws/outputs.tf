output "vault_s3_bucket_name" {
  value = aws_s3_bucket.vault_storage.id
}
