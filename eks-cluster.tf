resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.name}-k8s-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.cluster-sg.id]
    subnet_ids         = concat(module.eks-network.private_k8s_subnet_ids, module.eks-network.public_k8s_subnet_ids)

    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-role-attachment
  ]
}

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

resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-attachment" {
  for_each = {
    AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
  }

  policy_arn = each.value
  role       = aws_iam_role.eks-cluster-role.name
}