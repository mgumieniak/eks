output "aws_auth_id" {
  value = kubernetes_config_map.aws-auth-cm.id
}