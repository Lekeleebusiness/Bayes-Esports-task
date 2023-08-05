# The use of variables to make the code reusable and easy to read and understand
# This variable is for the cidr block for the VPC
variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "my-prod-vpc"
}

# This variable is for list of availability zones for that region,I selected just 3
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
# This variable is for the private subnets, there are 3 private subnets I chose
variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

#This variable is for the public subnets, there are 3 public subnets I chose
variable "public_subnets" {
  type = list(string)
  default =  ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "public_key_location"{
  default = "/Users/apple/.ssh/id_rsa.pub"
}

variable "private_key_location"{
  default = "/Users/apple/.ssh/id_rsa"
}