variable "oidc-provider-id" {
  description = "OIDC producer's id"
}

variable "oidc-provider-arn" {
  description = "OIDC producer's arn"
}

variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "eks-cluster-name" {
  description = "EKS cluster name"
}