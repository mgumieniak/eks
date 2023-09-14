variable "name" {
  default = "mgumieniak"
  description = "The Deployment environment"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  default = "172.17.0.0/16"
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(string)
  default = ["172.17.8.0/21", "172.17.24.0/21", "172.17.40.0/21"]
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(string)
  default = ["172.17.0.0/21", "172.17.16.0/21", "172.17.32.0/21"]
  description = "The CIDR block for the private subnet"
}

variable "availability_zones" {
  type        = list(string)
  description = "The az that the resources will be launched"
}
