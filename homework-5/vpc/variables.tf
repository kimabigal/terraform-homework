variable "environment" {
  description = "Environment tag (e.g., dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of 3 subnet CIDRs"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
}

variable "azs" {
  description = "List of 3 AZs (must match subnet_cidrs order)"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"] # Ohio
}