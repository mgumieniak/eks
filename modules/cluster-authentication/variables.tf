variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}


variable "node_role_arn" {
  description = "EKS node role arn"
}

variable "account_d" {
  description = "Account id"
}