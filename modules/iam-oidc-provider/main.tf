data "tls_certificate" "this" {
  url = var.issuer
}

resource "aws_iam_openid_connect_provider" "eks-iam-oidc-provider" {
  url = var.issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.this.certificates.0.sha1_fingerprint]

  tags = {
    Name        = "${var.name}-eks-iam-oidc-provider"
    Environment = var.environment
  }
}