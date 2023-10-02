terraform {
  cloud {
    organization = "mgumieniak"
    hostname = "app.terraform.io"

    workspaces {
      name = "eks"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

#provider "kubernetes" {
#  host                   = module.cluster.endpoint
#  cluster_ca_certificate = module.cluster.cluster_ca_certificate
#  exec {
#    api_version = "client.authentication.k8s.io/v1beta1"
#    command     = "aws"
#    args        = ["eks", "get-token", "--cluster-name", module.cluster.name]
#  }
#}

