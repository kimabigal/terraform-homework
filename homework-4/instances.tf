resource "aws_key_pair" "kaizen_key" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
  tags       = local.common_tags
}

# Launch in public1 by default
locals {
  launch_subnet_id = aws_subnet.public1.id
  user_data        = <<-EOT
    #!/bin/bash
    set -e
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y && apt-get install -y apache2
      systemctl enable apache2 && systemctl restart apache2
    else
      yum update -y && yum install -y httpd
      systemctl enable httpd && systemctl restart httpd
    fi
    echo "Hello from Homework 4 (Wordpress app placeholder)" > /var/www/html/index.html
  EOT
}

resource "aws_instance" "web" {
  ami                         = var.ec2["ami_id"]
  instance_type               = var.ec2["instance_type"]
  subnet_id                   = local.launch_subnet_id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.kaizen_key.key_name
  associate_public_ip_address = true
  user_data                   = local.user_data
  tags                        = local.common_tags
}