output "vpc_id" {
  value = aws_vpc.kaizen.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "key_pair_name" {
  value = aws_key_pair.kaizen_key.key_name
}

output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}