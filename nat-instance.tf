module "nat_instance" {
  source = "./nat-instance"

  for_each = local.private_subnets

  enabled = each.value.nat_instance_enabled

  vpc_id                   = module.vpc.vpc_id
  subnet_id                = module.subnets_private[each.key].subnet_id
  private_route_table_id   = module.subnets_private[each.key].route_table_id
  availability_zone        = module.subnets_private[each.key].availability_zone
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  nat_instance_type        = var.nat_instance_type
  cidr_block               = var.cidr_block

  context = module.this.context
}
