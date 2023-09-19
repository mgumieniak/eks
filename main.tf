data "aws_region" "current_region" {}

locals {
  availability_zones = [
    "${data.aws_region.current_region.name}a",
    "${data.aws_region.current_region.name}b",
    "${data.aws_region.current_region.name}c"
  ]
}

module "network" {
  source = "./modules/network"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.availability_zones
  environment          = var.environment
  region               = data.aws_region.current_region.name
}

module "eks-network" {
  source = "./modules/eks-network"

  name                     = var.name
  vpc_id                   = module.network.vpc_id
  public_k8s_subnets_cidr  = var.public_k8s_subnets_cidr
  private_k8s_subnets_cidr = var.private_k8s_subnets_cidr
  availability_zones       = local.availability_zones
  environment              = var.environment
  private_route_table_id   = module.network.private_route_table_id
  public_route_table_id    = module.network.public_route_table_id
  default_network_acl_id   = module.network.default_network_acl_id
  region                   = data.aws_region.current_region.name
}

module "iam-oidc-provider" {
  source = "./modules/iam-oidc-provider"

  issuer = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

module "vpc-cni" {
  source = "./modules/vpc-cni"

  oidc-provider-arn = module.iam-oidc-provider.arn
  oidc-provider-id  = module.iam-oidc-provider.id
  eks-cluster-name  = aws_eks_cluster.eks_cluster.name
}

module "cluster-authentication" {
  source = "./modules/cluster-authentication"

  name          = var.name
  environment   = var.environment
  node-role-arn = aws_iam_role.eks-node-role.arn
}

module "service-account" {
  source = "./modules/service-account"

  oidc-provider-arn = module.iam-oidc-provider.arn
  oidc-provider-url = module.iam-oidc-provider.url
}
