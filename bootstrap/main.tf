resource "cloudflare_r2_bucket" "terraform_state" {
  account_id    = var.cloudflare_account_id
  name          = "homelab-terraform-state-bucket"
  location      = "enam" # Eastern North America
  storage_class = "Standard"
}
