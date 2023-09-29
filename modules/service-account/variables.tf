variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "oidc-provider-arn" {
  description = "OIDC provider's id"
}

variable "oidc-provider-url" {
  description = "OIDC provider's url"
}

variable "namespace" {
  default = "default"
  description = "Namespace"
}

variable "account-id" {
  description = "Account id"
}