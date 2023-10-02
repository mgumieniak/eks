variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "private_k8s_subnets_id" {
  description = "Private subnets' id"
}

variable "public_k8s_subnets_id" {
  description = "Public subnets' id"
}