output "instance_id" { value = aws_instance.server.id }
output "public_ip"   { value = aws_instance.server.public_ip }
output "az"          { value = aws_instance.server.availability_zone }