output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets_id" {
  value = module.network.public_subnets_id
}

output "private_subnets_id" {
  value = module.network.private_subnets_id
}

output "vpc-sg" {
  value = module.network.vpc-sg
}