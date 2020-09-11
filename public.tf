module "public_label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.2"

  attributes = ["public"]
  tags       = { "Visibility" = "public" }

  context = module.this.context
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  tags = module.public_label.tags
}

module "subnets_public" {
  source = "./subnet"

  for_each = local.public_subnets

  vpc_id            = module.vpc.vpc_id
  availability_zone = each.value.az

  subnet_cidr_block        = each.value.cidr_block
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  subnet_name              = each.value.name
  public_route_enabled     = true
  igw_id                   = module.vpc.igw_id
  route_table_id           = aws_route_table.public.id

  context = module.this.context
}


#resource "aws_network_acl" "public" {
#  vpc_id     = module.vpc.vpc_id
#  subnet_ids = [for n in module.subnets_public : n.subnet_id]
#
#  egress {
#    rule_no    = 100
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 0
#    to_port    = 0
#    protocol   = "-1"
#  }
#
#  ingress {
#    rule_no    = 100
#    action     = "allow"
#    cidr_block = "0.0.0.0/0"
#    from_port  = 0
#    to_port    = 0
#    protocol   = "-1"
#  }
#
#  tags = module.public_label.tags
#}
