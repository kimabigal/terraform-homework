data "aws_ami" "ubuntu22" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
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
  effective_ami = coalesce(var.ami_id, data.aws_ami.ubuntu22.id)
}

resource "aws_instance" "server" {
  ami                         = local.effective_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}