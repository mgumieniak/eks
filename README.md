To destroy comment:
module "cluster-authentication"
module "service-account"
module "self-managed-group"

resource "aws_iam_role" "eks-node-role"
module "vpc-cni"
module "iam-oidc-provider" 

module "cluster"
module "eks-network"
module "network"
k8s provider 
output