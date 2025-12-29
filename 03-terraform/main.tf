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

resource "aws_instance" "sysmonitor" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 LTS (us-east-1)
  instance_type = var.instance_type

  tags = {
    Name = "sysmonitor-terraform"
    Project = "Cloud-DevOps-Portfolio"
  }
}

