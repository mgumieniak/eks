data "aws_region" "current_region" {}

locals {
  availability_zones = [
    "${data.aws_region.current_region.name}a",
    "${data.aws_region.current_region.name}b",
    "${data.aws_region.current_region.name}c"
  ]
}

module "networking" {
  source = "./modules/networking"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.availability_zones
  environment          = var.environment
}
