#########################################################
### Example of configuring a Kubernetes service account to assume an IAM role ######
data "aws_caller_identity" "current" {}

resource "kubernetes_service_account" "pod-service-account" {
  metadata {
    name = "pod-service-account"
  }
}

resource "kubernetes_cluster_role" "pod-role" {
  metadata {
    name = "pod-role"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "pod-role-binding" {
  metadata {
    name = "pod-role-binding"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.pod-service-account.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.pod-role.metadata[0].name
  }
}

resource "aws_iam_role" "pod-iam-role" {
  name = "${var.name}-pod-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Federated = var.oidc-provider-arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${var.oidc-provider-url}:aud" : "sts.amazonaws.com",
            "${var.oidc-provider-url}:sub" : "system:serviceaccount:${var.namespace}:${kubernetes_service_account.pod-service-account.metadata[0].name}"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "s3-list-bucket-policy"

    policy = jsonencode( {
      Version   = "2012-10-17"
      Statement = [
        {
          Effect = "Allow",
          "Action" : "s3:ListBucket",
          "Resource" : "*"
        },
      ]
    } )
  }

  tags = {
    Name        = "${var.name}-pod-role"
    Environment = var.environment
  }
}