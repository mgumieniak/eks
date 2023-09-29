resource "aws_subnet" "public_k8s_subnet" {
  count = length(var.public_k8s_subnets_cidr)

  vpc_id                  = var.vpc_id
  cidr_block              = element(var.public_k8s_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-${element(var.availability_zones, count.index)}-public-k8s-subnet"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_k8s_subnet" {
  count = length(var.private_k8s_subnets_cidr)

  vpc_id                  = var.vpc_id
  cidr_block              = element(var.private_k8s_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-${element(var.availability_zones, count.index)}-private-k8s-subnet"
    Environment = var.environment
  }
}

locals {
  ep_interface = toset([
#    "com.amazonaws.${var.region}.ecr.dkr",
#    "com.amazonaws.${var.region}.ecr.api",
#    "com.amazonaws.${var.region}.ssm",
#    "com.amazonaws.${var.region}.ec2messages",
#    "com.amazonaws.${var.region}.ec2",
#    "com.amazonaws.${var.region}.ssmmessages",
#    "com.amazonaws.${var.region}.sts"
  ])
  ep_gateway = toset(["com.amazonaws.${var.region}.s3"])
}

resource "aws_vpc_endpoint" "interfaces" {
  for_each = local.ep_interface

  vpc_id              = var.vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = each.value
  subnet_ids          = aws_subnet.private_k8s_subnet.*.id
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.vpc-def.id]
}

resource "aws_vpc_endpoint" "gateways" {
  for_each = local.ep_gateway

  vpc_id            = var.vpc_id
  vpc_endpoint_type = "Gateway"
  service_name      = each.value
  route_table_ids   = [var.private_route_table_id]
}