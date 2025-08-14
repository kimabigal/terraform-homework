terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

# VPC
resource "aws_vpc" "kaizen" {
  cidr_block           = local.vpc_cfg.cidr
  enable_dns_support   = local.vpc_cfg.dns_support
  enable_dns_hostnames = local.vpc_cfg.dns_hostnames
  tags                 = local.common_tags
}

# IGW
resource "aws_internet_gateway" "homework4_igw" {
  vpc_id = aws_vpc.kaizen.id
  tags   = merge(local.common_tags, { Name = var.igw_name })
}

# Subnets (explicit resources per instructor style)
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = local.subnet_by_name["public1"].cidr
  availability_zone       = local.subnet_by_name["public1"].az
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "public1" })
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = local.subnet_by_name["public2"].cidr
  availability_zone       = local.subnet_by_name["public2"].az
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "public2" })
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = local.subnet_by_name["private1"].cidr
  availability_zone       = local.subnet_by_name["private1"].az
  map_public_ip_on_launch = false
  tags                    = merge(local.common_tags, { Name = "private1" })
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = local.subnet_by_name["private2"].cidr
  availability_zone       = local.subnet_by_name["private2"].az
  map_public_ip_on_launch = false
  tags                    = merge(local.common_tags, { Name = "private2" })
}

# Route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kaizen.id
  tags   = merge(local.common_tags, { Name = var.route_table_names[0] })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.homework4_igw.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kaizen.id
  tags   = merge(local.common_tags, { Name = var.route_table_names[1] })
}

# Associations
resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}