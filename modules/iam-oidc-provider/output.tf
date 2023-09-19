output "arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks-iam-oidc-provider.arn
}

output "id" {
  value = aws_iam_openid_connect_provider.eks-iam-oidc-provider.id
}

output "url" {
  value = aws_iam_openid_connect_provider.eks-iam-oidc-provider.url
}