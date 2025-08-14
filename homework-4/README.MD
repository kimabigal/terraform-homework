```hcl
region = "us-west-2"

vpc = [
  {
    cidr          = "10.1.0.0/16"
    dns_support   = true
    dns_hostnames = true
  }
]

subnets = [
  { cidr = "10.1.1.0/24", az = "us-west-2a", map_public_ip_on_launch = true,  name = "public1"  },
  { cidr = "10.1.2.0/24", az = "us-west-2b", map_public_ip_on_launch = true,  name = "public2"  },
  { cidr = "10.1.3.0/24", az = "us-west-2c", map_public_ip_on_launch = false, name = "private1" },
  { cidr = "10.1.4.0/24", az = "us-west-2d", map_public_ip_on_launch = false, name = "private2" }
]

igw_name          = "homework4_igw"
route_table_names = ["public-rt", "private-rt"]
ports             = [22, 80, 443, 3306]

ec2 = {
  ami_id        = "ami-0ac098a0168eb72d0"
  instance_type = "t2.micro"
}
