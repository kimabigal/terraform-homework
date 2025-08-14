variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc" {
  type = list(object({
    cidr          = string
    dns_support   = bool
    dns_hostnames = bool
  }))
  default = [
    {
      cidr          = "10.1.0.0/16"
      dns_support   = true
      dns_hostnames = true
    }
  ]
}

variable "subnets" {
  type = list(object({
    cidr                    = string
    az                      = string
    map_public_ip_on_launch = bool
    name                    = string
  }))
  default = [
    { cidr = "10.1.1.0/24", az = "us-west-2a", map_public_ip_on_launch = true, name = "public1" },
    { cidr = "10.1.2.0/24", az = "us-west-2b", map_public_ip_on_launch = true, name = "public2" },
    { cidr = "10.1.3.0/24", az = "us-west-2c", map_public_ip_on_launch = false, name = "private1" },
    { cidr = "10.1.4.0/24", az = "us-west-2d", map_public_ip_on_launch = false, name = "private2" }
  ]
}

variable "igw_name" {
  type    = string
  default = "homework4_igw"
}

variable "route_table_names" {
  type    = list(string)
  default = ["public-rt", "private-rt"]
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 3306]
}

variable "ec2" {
  type = map(string)
  default = {
    ami_id        = "ami-0efcece6bed30fd98" # Ubuntu 22.04 LTS in us-west-2
    instance_type = "t2.micro"
  }
}

variable "key_pair_name" {
  type    = string
  default = "kaizen-homework4-key"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}