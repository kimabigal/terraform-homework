output "vpc_id" {
  value = aws_vpc.kaizen.id
}

output "subnet_ids" {
  value = {
    public1  = aws_subnet.this["public1"].id
    public2  = aws_subnet.this["public2"].id
    private1 = aws_subnet.this["private1"].id
    private2 = aws_subnet.this["private2"].id
  }
}

output "ubuntu_url" {
  value       = "http://${aws_instance.ubuntu.public_ip}"
  description = "Ubuntu Apache URL"
}

output "amazon_url" {
  value       = "http://${aws_instance.amazon.public_ip}"
  description = "Amazon Linux Apache URL"
}