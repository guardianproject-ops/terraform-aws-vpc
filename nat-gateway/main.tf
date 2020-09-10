module "nat_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"
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
  allocation_id = aws_eip.nat.*.id
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

resource "aws_route" "nat" {
  count                  = var.enabled ? 1 : 0
  route_table_id         = var.private_route_table_id
  nat_gateway_id         = aws_nat_gateway.nat.*.id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}
