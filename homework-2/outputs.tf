output "web_urls" {
  description = "Public URLs for testing Apache Hello World"
  value       = [for ip in aws_instance.web[*].public_ip : "http://${ip}"]
}

output "instance_azs" {
  description = "Availability Zones used by each instance"
  value       = aws_instance.web[*].availability_zone
}