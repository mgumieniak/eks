resource "aws_eks_node_group" "managed-group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name}-k8s-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  #  capacity_type = "SPOT"
  instance_types = ["t2.medium", "t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # Ensure that aws-auth is created before otherwise, node-group creates own
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-role-attachment,
    var.aws_auth_id
  ]

  tags = {
    Name = "${var.name}-self-managed-group"
    Environment = var.environment
  }
}


resource "aws_iam_role_policy_attachment" "eks-node-role-attachment" {
  for_each = {
    AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    AmazonEKS_ECR_Policy               = aws_iam_policy.access-ecr.arn
  }

  policy_arn = each.value
  role       = var.node_role_name
}

resource "aws_iam_policy" "access-ecr" {
  name        = "ecr-policy-for-eks"
  description = "Policy to access ECR images for EKS"

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

  tags = {
    Name = "${var.name}-ecr-policy-for-eks"
    Environment = var.environment
  }
}