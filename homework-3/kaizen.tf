terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

# VPC
resource "aws_vpc" "kaizen" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "kaizen" }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "homework3_igw" }
}


locals {
  subnets = {
    public1  = { cidr = "10.0.1.0/24", az = "us-west-2a", public = true }
    public2  = { cidr = "10.0.2.0/24", az = "us-west-2b", public = true }
    private1 = { cidr = "10.0.3.0/24", az = "us-west-2c", public = false }
    private2 = { cidr = "10.0.4.0/24", az = "us-west-2d", public = false }
  }
}

resource "aws_subnet" "this" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public
  tags                    = { Name = each.key }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "public-rt" }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "private-rt" }
}


locals {
  public_keys  = ["public1", "public2"]
  private_keys = ["private1", "private2"]
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