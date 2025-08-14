terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

resource "aws_vpc" "kaizen" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "kaizen" }
}

resource "aws_internet_gateway" "homework3_igw" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "homework3_igw" }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public1" }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags                    = { Name = "public2" }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false
  tags                    = { Name = "private1" }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.kaizen.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-west-2d"
  map_public_ip_on_launch = false
  tags                    = { Name = "private2" }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "public-rt" }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.homework3_igw.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kaizen.id
  tags   = { Name = "private-rt" }
}


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