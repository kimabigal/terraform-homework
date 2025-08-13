variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "Bastion"
}

# Intentional duplicate per assignment
variable "instance_names" {
  description = "Names for the 3 instances"
  type        = list(string)
  default     = ["web-1", "web-2", "web-2"]
}