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

variable "ssh_public_key" {
  description = "Public SSH key for EC2 access"
  type        = string
}

resource "aws_key_pair" "sysmonitor_key" {
  key_name   = "sysmonitor-key"
  public_key = var.ssh_public_key
}

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

