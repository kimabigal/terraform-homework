terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

# -------- Tags (locals, as requested) --------
locals {
  common_tags = {
    Name        = "Kaizen"
    Environment = "Dev"
    Department  = "Engineering"
    Team        = "DevOps"
    CreatedBy   = "manual"
    Owner       = "Abigail"      # <-- your name here
    Project     = "E-commerce"
    Application = "Wordpress"
  }
}

# -------- VPC --------
# Use first (and only) object in the vpc list
locals {
  vpc_cfg = var.vpc[0]
}

resource "aws_vpc" "this" {
  cidr_block           = local.vpc_cfg.cidr
  enable_dns_support   = local.vpc_cfg.dns_support
  enable_dns_hostnames = local.vpc_cfg.dns_hostnames
  tags = local.common_tags
}

# -------- IGW --------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = var.igw_name })
}

# -------- Subnets (loop) --------
locals {
  subnet_map = { for s in var.subnets : s.name => s }
}

resource "aws_subnet" "this" {
  for_each                  = local.subnet_map
  vpc_id                    = aws_vpc.this.id
  cidr_block                = each.value.cidr
  availability_zone         = each.value.az
  map_public_ip_on_launch   = each.value.map_public_ip_on_launch
  tags                      = merge(local.common_tags, { Name = each.key })
}

# -------- Route Tables + default route for public --------
locals {
  rt_public_name  = var.route_table_names[0]
  rt_private_name = var.route_table_names[1]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = local.rt_public_name })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = local.rt_private_name })
}

# -------- Associate subnets to RTs --------
locals {
  public_keys  = [for k, v in local.subnet_map : k if v.map_public_ip_on_launch]
  private_keys = [for k, v in local.subnet_map : k if !v.map_public_ip_on_launch]
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = toset(local.public_keys)
  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = toset(local.private_keys)
  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = aws_route_table.private.id
}
