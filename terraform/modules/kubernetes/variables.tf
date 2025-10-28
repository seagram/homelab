variable "tailscale_oauth_client_id" {
  type        = string
}

variable "tailscale_oauth_client_secret" {
  type        = string
  sensitive   = true
}

variable "admin_password" {
  type        = string
  sensitive   = true
}