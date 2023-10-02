resource "kubernetes_config_map" "aws-auth-cm" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      {
        rolearn  = aws_iam_role.eks-admin-role.arn
        username = "kube-admin"
        groups   = [
          "system:masters"
        ]
      },
      {
        rolearn  = aws_iam_role.test.arn
        username = "test-viewer"
        groups   = [
          "test-viewer",
        ]
      }
    ])
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${var.account_d}:user/maciej"
        username = "eks-admin"
        groups   = [
          "system:masters"
        ]
      }
    ])
  }
}

resource "aws_iam_role" "eks-admin-role" {
  name = "${var.name}-eks-admin-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_d}:root"
        },
        "Action" : "sts:AssumeRole",
      },
    ]
  })

  tags = {
    Name        = "${var.name}-eks-admin-role"
    Environment = var.environment
  }
}

resource "kubernetes_namespace" "test-namespace" {
  metadata {
    labels = {
      Name = "test"
    }

    name = "test"
  }
}

#########################################################
### Example of role for accessing pods in test env via kubectl######
resource "aws_iam_role" "test" {
  name = "${var.name}-eks-test-pods-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_d}:root"
        },
        "Action" : "sts:AssumeRole",
      },
    ]
  })

  tags = {
    Name        = "${var.name}-eks-test-pods-role"
    Environment = var.environment
  }
}

resource "kubernetes_role" "pod-reader-role" {
  metadata {
    name = "pod-reader-role"
    namespace = var.environment
    labels = {
      test = "MyRoles"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "pod-reader-role-binding" {
  metadata {
    name = "pod-reader-role-binding"
    namespace = var.environment
    labels = {
      test = "MyRoleBinding"
    }
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind = "Group"
    name = "test-viewer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.pod-reader-role.metadata[0].name
  }
}