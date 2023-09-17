resource "aws_subnet" "public_k8s_subnet" {
  count                   = length(var.public_k8s_subnets_cidr)

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
  count                   = length(var.private_k8s_subnets_cidr)

  vpc_id                  = var.vpc_id
  cidr_block              = element(var.private_k8s_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name}-${element(var.availability_zones, count.index)}-private-k8s-subnet"
    Environment = var.environment
  }
}
