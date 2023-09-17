resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_k8s_subnets_cidr)

  subnet_id      = element(aws_subnet.public_k8s_subnet.*.id, count.index)
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_k8s_subnets_cidr)

  subnet_id      = element(aws_subnet.private_k8s_subnet.*.id, count.index)
  route_table_id = var.private_route_table_id
}