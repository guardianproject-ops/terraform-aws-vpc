module "nat_instance" {
  source = "./nat-instance"

  for_each = var.nat_instances

  enabled = length(each.value) > 0

  vpc_id = module.vpc.vpc_id

  public_subnet_id       = length(each.value) > 0 ? module.subnets_public[each.value].subnet_id : ""
  private_route_table_id = aws_route_table.private[each.key].id

  availability_zone        = each.key
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  nat_instance_type        = var.nat_instance_type
  cidr_block               = var.cidr_block

  attributes = [each.key, each.value]
  context    = module.this.context
}
