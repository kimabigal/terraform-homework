output "ubuntu_url" { value = "http://${aws_instance.ubuntu.public_ip}" }
output "amazon_url" { value = "http://${aws_instance.amazon.public_ip}" }

