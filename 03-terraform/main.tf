terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



########################
# Security Group
########################

resource "aws_security_group" "sysmonitor_sg" {
  name        = "sysmonitor-sg"
  description = "Allow SSH access to sysmonitor EC2 instance"

  ingress {
    description = "SSH access"
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

  tags = {
    Name    = "sysmonitor-sg"
    Project = "Cloud-DevOps-Portfolio"
  }
}

########################
# SSH Key Pair
########################

resource "aws_key_pair" "sysmonitor_key" {
  key_name   = "sysmonitor-key"
  public_key = var.ssh_public_key
}

########################
# EC2 Instance
########################

resource "aws_instance" "sysmonitor" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = var.instance_type
  key_name      = aws_key_pair.sysmonitor_key.key_name
  user_data     = file("${path.module}/user_data.sh")

  vpc_security_group_ids = [
    aws_security_group.sysmonitor_sg.id
  ]

  tags = {
    Name    = "sysmonitor-terraform"
    Project = "Cloud-DevOps-Portfolio"
  }
}

