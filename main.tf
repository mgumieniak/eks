data "aws_region" "current-region" {}

data "aws_caller_identity" "this" {}

locals {
  availability_zones = [
    "${data.aws_region.current-region.name}a",
    "${data.aws_region.current-region.name}b",
    "${data.aws_region.current-region.name}c"
  ]
}

#module "network" {
#  source = "./modules/network"
#
#  name                 = var.name
#  vpc_cidr             = var.vpc_cidr
#  public_subnets_cidr  = var.public_subnets_cidr
#  private_subnets_cidr = var.private_subnets_cidr
#  availability_zones   = local.availability_zones
#  environment          = var.environment
#  region               = data.aws_region.current-region.name
#}
#
#module "eks-network" {
#  source = "./modules/eks-network"
#
#  name                     = var.name
#  vpc_id                   = module.network.vpc_id
#  public_k8s_subnets_cidr  = var.public_k8s_subnets_cidr
#  private_k8s_subnets_cidr = var.private_k8s_subnets_cidr
#  availability_zones       = local.availability_zones
#  environment              = var.environment
#  private_route_table_id   = module.network.private_route_table_id
#  public_route_table_id    = module.network.public_route_table_id
#  default_network_acl_id   = module.network.default_network_acl_id
#  region                   = data.aws_region.current-region.name
#}
#
#module "cluster" {
#  source                 = "./modules/cluster"
#  private_k8s_subnets_id = module.eks-network.private_k8s_subnet_ids
#  public_k8s_subnets_id  = module.eks-network.public_k8s_subnet_ids
#  vpc_id                 = module.network.vpc_id
#}

#module "iam-oidc-provider" {
#  source = "./modules/iam-oidc-provider"
#
#  issuer = module.cluster.issuer
#}
#
#module "vpc-cni" {
#  source = "./modules/vpc-cni"
#
#  oidc_provider_arn = module.iam-oidc-provider.arn
#  oidc_provider_id  = module.iam-oidc-provider.id
#  eks_cluster_name  = module.cluster.name
#}

#resource "aws_iam_role" "eks-node-role" {
#  name = "${var.name}-eks-node-role"
#
#  assume_role_policy = jsonencode({
#    Version   = "2012-10-17"
#    Statement = [
#      {
#        Effect    = "Allow",
#        Principal = {
#          Service = "ec2.amazonaws.com"
#        },
#        "Action" : "sts:AssumeRole"
#      },
#    ]
#  })
#
#  tags = {
#    Name        = "${var.name}-eks-node-group"
#    Environment = var.environment
#  }
#}

#module "cluster-authentication" {
#  source = "./modules/cluster-authentication"
#
#  name          = var.name
#  environment   = var.environment
#  node_role_arn = aws_iam_role.eks-node-role.arn
#  account_d    = data.aws_caller_identity.this.account_id
#}
#
#module "service-account" {
#  source = "./modules/service-account"
#
#  oidc_provider_arn = module.iam-oidc-provider.arn
#  oidc_provider_url = module.iam-oidc-provider.url
#  account_id        = data.aws_caller_identity.this.account_id
#}

#module "self-managed-group" {
#  source         = "./modules/self-managed-group"
#  aws_auth_id    = module.cluster-authentication.aws_auth_id
#  cluster_name   = module.cluster.name
#  subnet_ids     = module.eks-network.private_k8s_subnet_ids
#  node_role_name = aws_iam_role.eks-node-role.name
#  node_role_arn  = aws_iam_role.eks-node-role.arn
#}
