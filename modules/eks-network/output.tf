output "private_k8s_subnet_ids" {
  value = aws_subnet.private_k8s_subnet.*.id
}

output "public_k8s_subnet_ids" {
  value = aws_subnet.public_k8s_subnet.*.id
}