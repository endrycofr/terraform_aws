terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Key pair (untuk SSH). Simpel: generate baru. Jangan commit private key!
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "hello-ec2-key"
  public_key = tls_private_key.this.public_key_openssh
}

# Simpan private key ke file lokal
resource "local_file" "private_key_pem" {
  filename = "./hello-ec2-key.pem"
  content  = tls_private_key.this.private_key_pem
  file_permission = "0400"
}

# Security Group: HTTP/80 dari mana saja, SSH/22 dari CIDR yang ditentukan
resource "aws_security_group" "web_sg" {
  name        = "hello-web-sg"
  description = "Allow HTTP and limited SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ambil default VPC & subnet (untuk kemudahan demo)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# AMI Amazon Linux 2023 terbaru
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Amazon Linux 2 default AMI
  }

  owners = ["137112412989"]  # Amazon
}


# User data untuk install httpd, clone repo, dan opsional runner
locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    repo_url            = var.repo_url
    branch              = var.branch
    github_repo         = var.github_repo
    github_runner_token = var.github_runner_token
    HOSTNAME            = "my-ec2-host"
  })
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.default.ids, 0)
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.this.key_name

  user_data              = local.user_data

  tags = {
    Name = "hello-world-ec2"
  }
}