output "vpc" {
  value = module.vpc
}

output "public_subnets" {
  value = module.subnets_public
}

output "private_subnets" {
  value = module.subnets_private
}


output "nat_gateways" {
  value = { for k, n in module.nat_gateway : k => n if length(n.id) > 0 }
}

output "nat_instances" {
  value = { for k, n in module.nat_instance : k => n if length(n.id) > 0 }
}


output "ssh_security_group_id" {
  value = aws_security_group.sg_allow_ssh.id
}
