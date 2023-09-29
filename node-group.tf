#resource "aws_eks_node_group" "example" {
#  cluster_name    = aws_eks_cluster.eks_cluster.name
#  node_group_name = "${var.name}-k8s-node-group"
#  node_role_arn   = aws_iam_role.eks-node-role.arn
#  subnet_ids      = module.eks-network.private_k8s_subnet_ids
##  capacity_type = "SPOT"
#  instance_types = ["t2.medium", "t3.medium"]
#
#  scaling_config {
#    desired_size = 1
#    max_size     = 2
#    min_size     = 1
#  }
#
#  update_config {
#    max_unavailable = 1
#  }
#
#  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#  # Ensure that aws-auth is created before otherwise, node-group creates own
#  depends_on = [
#    aws_iam_role_policy_attachment.eks-node-role-attachment,
#    module.cluster-authentication
#  ]
#}

resource "aws_iam_role" "eks-node-role" {
  name = "${var.name}-eks-node-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-node-role-attachment" {
  for_each = {
    AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    AmazonEKS_ECR_Policy               = aws_iam_policy.access-ecr.arn
  }

  policy_arn = each.value
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_policy" "access-ecr" {
  name        = "ecr-policy-for-eks"
  description = "Policy to access ECR images with EKS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
    ]
  })
}