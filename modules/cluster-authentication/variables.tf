variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}


variable "node-role-arn" {
  description = "EKS node role arn"
}

variable "account-id" {
  description = "Account id"
}