variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "cluster_name" {
  description = "Cluster name"
}

variable "subnet_ids" {
  type = list(string)
  description = "Subnets id (recommended private)"
}

variable "aws_auth_id" {
  description = "aws-auth id which should be created before node group"
}

variable "node_role_name" {
  description = "EKS node role name"
}

variable "node_role_arn" {
  description = "EKS node role arn"
}
