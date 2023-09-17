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
}


#resource "aws_eks_cluster" "eks_cluster" {
#  name     = "${var.name}-k8s-cluster"
#  role_arn = aws_iam_role.eks-cluster-role.arn
#
#  vpc_config {
#    security_group_ids = [aws_security_group.cluster-sg.id]
#    subnet_ids         = concat(module.eks-network.private_k8s_subnet_ids, module.eks-network.public_k8s_subnet_ids)
#  }
#}

resource "aws_security_group" "cluster-sg" {
  name        = "${var.name}-k8s-cluster-sg"
  description = "Security group for the ${var.name}-k8s"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "all"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "all"
    self      = true
  }

  tags = {
    Name        = "${var.name}-vpc-sg"
    Environment = var.environment
  }
}
