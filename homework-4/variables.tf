variable "region" {
  description = "AWS region"
  type        = string
}

# ---------- VPC (list of objects) ----------
variable "vpc" {
  description = "VPC settings (list with one object: cidr, dns flags)"
  type = list(object({
    cidr           = string
    dns_support    = bool
    dns_hostnames  = bool
  }))
}

# ---------- Subnets (list of objects) ----------
variable "subnets" {
  description = "Subnets to create: cidr, az, auto-assign public IP, name"
  type = list(object({
    cidr                  = string
    az                    = string
    map_public_ip_on_launch = bool
    name                  = string
  }))
}

# ---------- Internet Gateway (string) ----------
variable "igw_name" {
  description = "Internet Gateway name"
  type        = string
}

# ---------- Route table names (list of strings) ----------
variable "route_table_names" {
  description = "Route tables in order: [public-rt, private-rt]"
  type        = list(string)
}

# ---------- Security Group ports (list of numbers) ----------
variable "ports" {
  description = "Ingress ports (e.g., [22, 80, 443, 3306])"
  type        = list(number)
}

# ---------- EC2 info (map of strings) ----------
variable "ec2" {
  description = "EC2 settings map with keys: ami_id, instance_type"
  type        = map(string)
}

# ---------- Key pair (so we can tag it) ----------
variable "key_pair_name" {
  description = "EC2 Key Pair name to create"
  type        = string
}

variable "public_key_path" {
  description = "Path to your local SSH public key (e.g., ~/.ssh/id_ed25519.pub)"
  type        = string
}