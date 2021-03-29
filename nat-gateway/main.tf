module "nat_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"
  attributes = ["nat"]
  context    = module.this.context
}

resource "aws_eip" "nat" {
  count = var.enabled ? 1 : 0
  tags = merge(
    module.nat_label.tags,
    {
      "Name" = module.nat_label.id
    },
  )
}
resource "aws_nat_gateway" "nat" {
  count         = var.enabled ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = var.public_subnet_id
  tags = merge(
    module.nat_label.tags,
    {
      "Name" = module.nat_label.id
    },
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "nat_ipv4" {
  count                  = var.enabled ? 1 : 0
  route_table_id         = var.private_route_table_id
  nat_gateway_id         = aws_nat_gateway.nat[0].id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}
#resource "aws_route" "nat_ipv6" {
#  count                       = var.enabled ? 1 : 0
#  route_table_id              = var.private_route_table_id
#  nat_gateway_id              = aws_nat_gateway.nat[0].id
#  destination_ipv6_cidr_block = "::/0"
#
#  timeouts {
#    create = var.aws_route_create_timeout
#    delete = var.aws_route_delete_timeout
#  }
#}
