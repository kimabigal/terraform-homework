locals {
  common_tags = {
    Name        = "Kaizen"
    Environment = "Dev"
    Department  = "Engineering"
    Team        = "DevOps"
    CreatedBy   = "manual"
    Owner       = "Your Name" # <-- set your name in terraform.tfvars if you prefer
    Project     = "E-commerce"
    Application = "Wordpress"
  }
}

# Convenience locals for config
locals {
  vpc_cfg           = var.vpc[0]
  subnet_by_name    = { for s in var.subnets : s.name => s }
  public_subnet_ns  = [for s in var.subnets : s.name if s.map_public_ip_on_launch]
  private_subnet_ns = [for s in var.subnets : s.name if !s.map_public_ip_on_launch]
}