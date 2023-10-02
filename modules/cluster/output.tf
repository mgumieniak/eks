output "name" {
  value = aws_eks_cluster.eks-cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
}
output "issuer" {
  value = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}


