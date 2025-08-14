resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "vpc-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "igw-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true
  tags = {
    Name        = "subnet1-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true
  tags = {
    Name        = "subnet2-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidrs[2]
  availability_zone       = var.azs[2]
  map_public_ip_on_launch = true
  tags = {
    Name        = "subnet3-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "public-rt-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route" "default_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.public_rt.id
}