#resource "aws_iam_role" "vpc-cni-role" {
#  name = "${var.name}-vpc-cni-role"
#
#  assume_role_policy = jsonencode({
#    Version   = "2012-10-17"
#    Statement = [
#      {
#        Effect    = "Allow",
#        Principal = {
#          Federated = var.oidc-provider-arn
#        },
#        "Action" : "sts:AssumeRoleWithWebIdentity",
#        "Condition" : {
#          "StringEquals" : {
#            "oidc.eks.eu-west-1.amazonaws.com/id/${var.oidc-provider-id}:aud" : "sts.amazonaws.com",
#            "oidc.eks.eu-west-1.amazonaws.com/id/${var.oidc-provider-id}:sub" : "system:serviceaccount:kube-system:aws-node"
#          }
#        }
#      },
#    ]
#  })
#
#  tags = {
#    Name        = "${var.name}-vpc-cni-role"
#    Environment = var.environment
#  }
#}
#
#resource "aws_eks_addon" "vpc-cni" {
#  cluster_name                = var.eks-cluster-name
#  addon_name                  = "vpc-cni"
#  resolve_conflicts_on_create = "OVERWRITE"
#  resolve_conflicts_on_update = "PRESERVE"
#  service_account_role_arn    = aws_iam_role.vpc-cni-role.arn
#
#  tags = {
#    Name        = "${var.name}-vpc-cni"
#    Environment = var.environment
#  }
#}
#
#resource "aws_iam_role_policy_attachment" "vpc-cni-role-attachment" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.vpc-cni-role.name
#}