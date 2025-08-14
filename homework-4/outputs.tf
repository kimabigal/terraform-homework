output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = { for k, s in aws_subnet.this : k => s.id }
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "key_pair_name" {
  value = aws_key_pair.this.key_name
}

output "web_url" {
  value = "http://${aws_instance.web.public_ip}"
}
