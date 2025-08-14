variable "region" {
  type    = string
  default = "us-east-2" # Ohio
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "subnet_cidrs" {
  type    = list(string)
  default = [
    "10.20.1.0/24",
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]
}

variable "azs" {
  type    = list(string)
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

variable "ami_id" {
  type    = string
  default = null
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_names" {
  type    = list(string)
  default = ["app-1", "app-2", "app-3"]
}