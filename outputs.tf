output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets_id" {
  value = module.networking.public_subnets_id
}

output "private_subnets_id" {
  value = module.networking.private_subnets_id
}

output "vpc-sg" {
  value = module.networking.vpc-sg
}