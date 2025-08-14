variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for the instance (if null, latest Ubuntu 22.04 will be used)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet to place the instance in"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "app"
}