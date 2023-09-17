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