terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

module "vpc" {
  source       = "../vpc"
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  azs          = var.azs
}

module "app1" {
  source        = "../ec2"
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[0]
  instance_name = var.instance_names[0]
}

module "app2" {
  source        = "../ec2"
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[1]
  instance_name = var.instance_names[1]
}

module "app3" {
  source        = "../ec2"
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_ids[2]
  instance_name = var.instance_names[2]
}