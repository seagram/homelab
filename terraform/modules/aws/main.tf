terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.23.0"
    }
  }
}

resource "tailscale_tailnet_key" "this" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
  description   = "AWS EC2 for HashiCorp Vault"
}

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]

}



resource "aws_security_group" "vault" {
  name        = "vault-security-group"
  description = "No public inbound access (Tailscale only)"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "vault" {
  depends_on    = [tailscale_tailnet_key.this, aws_security_group.vault]
  ami           = data.aws_ami.debian.id
  instance_type = "t3.nano"

  vpc_security_group_ids = [aws_security_group.vault.id]
  iam_instance_profile   = aws_iam_instance_profile.vault.name

  user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    disable_root: true
    runcmd:
      - ['touch', '/home/admin/.hushlogin']
      - ['chown', 'admin:admin', '/home/admin/.hushlogin']
      - ['hostnamectl', 'set-hostname', 'vault']
      - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
      - ['tailscale', 'up', '--auth-key=${tailscale_tailnet_key.this.key}', '--hostname=vault']
      - ['tailscale', 'set', '--ssh']
      - ['sed', '-i', 's/^#*PasswordAuthentication.*/PasswordAuthentication no/', '/etc/ssh/sshd_config']
      - ['sed', '-i', 's/^#*PubkeyAuthentication.*/PubkeyAuthentication no/', '/etc/ssh/sshd_config']
      - ['systemctl', 'restart', 'sshd']
  EOF
}

resource "aws_s3_bucket" "vault_storage" {
  bucket = "seagram-homelab-vault-storage"
}

resource "aws_s3_bucket_versioning" "vault_storage" {
  bucket = aws_s3_bucket.vault_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "vault" {
  name = "vault-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "vault_s3" {
  name = "vault-s3-access"
  role = aws_iam_role.vault.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.vault_storage.arn,
          "${aws_s3_bucket.vault_storage.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "vault" {
  name = "vault-instance-profile"
  role = aws_iam_role.vault.name
}
