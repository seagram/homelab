terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tailscale = {
      source = "tailscale/tailscale"
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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
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
  depends_on = [tailscale_tailnet_key.this, aws_security_group.vault]
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids      = [aws_security_group.vault.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #cloud-config
    ssh_pwauth: false
    disable_root: true
    runcmd:
      - ['touch', '/home/ubuntu/.hushlogin']
      - ['chown', 'ubuntu:ubuntu', '/home/ubuntu/.hushlogin']
      - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
      - ['tailscale', 'up', '--auth-key=${tailscale_tailnet_key.this.key}', '--hostname=vault']
      - ['tailscale', 'set', '--ssh']
      - ['sed', '-i', 's/^#*PasswordAuthentication.*/PasswordAuthentication no/', '/etc/ssh/sshd_config']
      - ['sed', '-i', 's/^#*PubkeyAuthentication.*/PubkeyAuthentication no/', '/etc/ssh/sshd_config']
      - ['systemctl', 'restart', 'sshd']
  EOF
}