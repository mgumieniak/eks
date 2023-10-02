variable "oidc_provider_id" {
  description = "OIDC producer's id"
}

variable "oidc_provider_arn" {
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

variable "eks_cluster_name" {
  description = "EKS cluster name"
}