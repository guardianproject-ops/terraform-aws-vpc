module "subnets_public" {
  source = "./subnet"

  for_each = local.public_subnets

  vpc_id            = module.vpc.vpc_id
  availability_zone = each.value.availability_zone

  subnet_cidr_block        = each.value.cidr_block
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  type                     = each.value.type
  public_route_enabled     = each.value.public_route_enabled
  igw_id                   = module.vpc.igw_id

  context = module.this.context
}

module "subnets_private" {
  source = "./subnet"

  for_each = local.private_subnets

  vpc_id            = module.vpc.vpc_id
  availability_zone = each.value.availability_zone

  subnet_cidr_block        = each.value.cidr_block
  aws_route_create_timeout = var.aws_route_create_timeout
  aws_route_delete_timeout = var.aws_route_delete_timeout
  type                     = each.value.type
  public_route_enabled     = each.value.public_route_enabled
  igw_id                   = module.vpc.igw_id

  context = module.this.context
}

resource "aws_network_acl" "public" {
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [for n in module.subnets_public : n.subnet_id]

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = module.this.tags
}
