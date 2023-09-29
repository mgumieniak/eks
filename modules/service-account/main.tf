####################################################################################
### Example of configuring a Kubernetes service account to assume an IAM role ######

locals {
  pod-iam-role-name = "${var.name}-pod-role"
  sa-token-name = "pod-service-account-token"
}

resource "kubernetes_service_account_v1" "pod-service-account" {
  metadata {
    name        = "pod-service-account"
    namespace   = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account-id}:role/${local.pod-iam-role-name}"
    }
  }
  secret {
    name = local.sa-token-name
  }
}

resource "kubernetes_secret_v1" "this" {
  type = "kubernetes.io/service-account-token"
  metadata {
    name        = local.sa-token-name
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.pod-service-account.metadata[0].name
    }
  }
}

resource "kubernetes_role_v1" "pod-role" {
  metadata {
    name      = "pod-role"
    namespace = "default" # TODO: change to test  https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions
  }

  rule {
    api_groups = [""]
    resources  = [""]
    verbs      = [""]
  }
}

resource "kubernetes_role_binding_v1" "pod-role-binding" {
  metadata {
    name      = "pod-role-binding"
    namespace = "default"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account_v1.pod-service-account.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.pod-role.metadata[0].name
  }
}

resource "aws_iam_role" "pod-iam-role" {
  name = local.pod-iam-role-name

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
            "${var.oidc-provider-url}:sub" : "system:serviceaccount:${var.namespace}:${kubernetes_service_account_v1.pod-service-account.metadata[0].name}"
          }
        }
      }
    ]
  })

  managed_policy_arns = [aws_iam_policy.s3-list-bucket-policy.arn]

  tags = {
    Name = "${var.name}-pod-role"
  }
}

resource "aws_iam_policy" "s3-list-bucket-policy" {
  name        = "s3-list-bucket-policy"
  description = "Policy to access S3 bucket"

  policy = jsonencode( {
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "*"
      },
    ]
  } )
}