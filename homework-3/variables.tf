variable "region" {
  type    = string
  default = "us-west-2"
}

variable "key_name" {
  type    = string
  default = "my-lapto-key-canada" 
}

variable "ubuntu_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "amazon_instance_type" {
  type    = string
  default = "t2.micro"
}
