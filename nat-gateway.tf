module "nat_gateway" {
  source = "./nat-gateway"

  for_each = local.private_subnets

  enabled = each.value.nat_gateway_enabled

  vpc_id                   = module.vpc.vpc_id
  public_subnet_id         = module.subnets_private[each.key].subnet_id
  private_route_table_id   = module.subnets_private[each.key].route_table_id
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout

  context = module.this.context
}
