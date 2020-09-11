output "vpc" {
  value = module.vpc
}

output "availability_zones" {
  value = var.availability_zones
}

output "private_route_tables" {
  value = aws_route_table.private
}

output "nat_gateways" {
  value = module.nat_gateway
}

output "nat_instances" {
  value = module.nat_instance
}

output "public_subnets" {
  value = module.subnets_public
}

output "private_subnets" {
  value = module.subnets_private
}

output "ssh_security_group_id" {
  value = aws_security_group.sg_allow_ssh.id
}
