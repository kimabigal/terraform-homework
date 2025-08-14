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


data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


locals {
  ubuntu_ud = <<-EOT
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y apache2
    echo "Hello, World! (Ubuntu)" > /var/www/html/index.html
    systemctl enable apache2
    systemctl restart apache2
  EOT

  amazon_ud = <<-EOT
    #!/bin/bash
    set -e
    yum update -y
    yum install -y httpd
    echo "Hello, World! (Amazon Linux 2)" > /var/www/html/index.html
    systemctl enable httpd
    systemctl restart httpd
  EOT
}

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu22.id
  instance_type               = var.ubuntu_instance_type
  subnet_id                   = aws_subnet.this["public1"].id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = local.ubuntu_ud
  tags                        = { Name = "Ubuntu" }
}


resource "aws_instance" "amazon" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.amazon_instance_type
  subnet_id                   = aws_subnet.this["public2"].id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = local.amazon_ud
  tags                        = { Name = "Amazon" }
}