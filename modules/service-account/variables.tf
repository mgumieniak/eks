variable "name" {
  default = "mgumieniak"
  description = "The Deployment name"
}

variable "environment" {
  default = "test"
  description = "The Deployment environment"
}

variable "oidc_provider_arn" {
  description = "OIDC provider's id"
}

variable "oidc_provider_url" {
  description = "OIDC provider's url"
}

variable "account_id" {
  description = "Account id"
}