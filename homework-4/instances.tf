# Create a Key Pair so we can TAG it (and use it)
resource "aws_key_pair" "this" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)
  tags       = local.common_tags
}

# Pick the first public subnet to launch the instance
locals {
  public_subnet_ids = [for s in aws_subnet.this : s.id if s.map_public_ip_on_launch]
  launch_subnet_id  = element(local.public_subnet_ids, 0)
}

# Simple user data to install Apache regardless of distro
locals {
  user_data = <<-EOT
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
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = local.common_tags
}
