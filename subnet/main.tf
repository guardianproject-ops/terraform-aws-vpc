module "subnet_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"
  attributes = [var.subnet_name]
  tags       = { "Visibility" = var.public_route_enabled ? "public" : "private" }
  context    = module.this.context
}

resource "aws_subnet" "subnet" {
  cidr_block              = var.subnet_cidr_block
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.public_route_enabled

  tags = merge(
    module.subnet_label.tags,
    {
      "Name" = format(
        "%s%s%s",
        module.subnet_label.id,
        module.this.delimiter,
        replace(
          var.availability_zone,
          "-",
          module.this.delimiter
        )
      )
    }
  )

  lifecycle {
    ignore_changes = [tags.Visibility]
  }
}

resource "aws_route" "public" {
  count                  = var.public_route_enabled ? 1 : 0
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}

resource "aws_route_table_association" "subnet" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}

