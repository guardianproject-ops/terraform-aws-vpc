module "private_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"

  attributes = ["private"]
  tags       = { "Visibility" = "private" }

  context = module.this.context
}

# create a private route table per AZ
resource "aws_route_table" "private" {

  # note: this looks like it is per subnet, but is actually per az
  for_each = var.subnets

  vpc_id = module.vpc.vpc_id

  tags = merge(
    module.private_label.tags,
    {
      "Name" = format(
        "%s%s%s",
        module.private_label.id,
        module.this.delimiter,
        replace(
          each.key,
          "-",
          module.this.delimiter
        )
      )
    }
  )
}

module "subnets_private" {
  source = "./subnet"

  for_each = local.private_subnets

  vpc_id            = module.vpc.vpc_id
  availability_zone = each.value.az

  subnet_cidr_block        = each.value.cidr_block
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  subnet_name              = each.value.name
  public_route_enabled     = false
  igw_id                   = module.vpc.igw_id
  route_table_id           = aws_route_table.private[each.value.az].id

  context = module.this.context
}
