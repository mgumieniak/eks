variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "vpc_id" {
  type = string
  description = "The vpc id"
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

variable "availability_zones" {
  type        = list(string)
  description = "The az that the resources will be launched"
}

variable "private_route_table_id" {
  type = string
  description = "Private route's table id"
}

variable "public_route_table_id" {
  type = string
  description = "Public route's table id"
}

variable "default_network_acl_id" {
  type = string
  description = "Default network acl id"
}