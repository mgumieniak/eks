variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
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

variable "public_k8s_subnets_cidr" {
  type        = list(string)
  default = ["172.17.56.0/21", "172.17.72.0/21"]
  description = "The CIDR block for the public subnet"
}

variable "private_k8s_subnets_cidr" {
  type        = list(string)
  default = ["172.17.48.0/21", "172.17.64.0/21"]
  description = "The CIDR block for the private subnet"
}
