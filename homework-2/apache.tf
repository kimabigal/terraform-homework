terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_az_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    echo "Hello, World!" > /var/www/html/index.html
    systemctl enable apache2
    systemctl restart apache2
  EOT
}


resource "aws_instance" "web" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu22.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default_az_subnets.ids[count.index]
  vpc_security_group_ids      = [aws_security_group.web_sg.id] # from security-groups.tf
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = { Name = var.instance_names[count.index] }
}

