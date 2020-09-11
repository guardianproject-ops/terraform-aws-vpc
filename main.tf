module "vpc" {
  #source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref = tags/0.17.0"
  source     = "./vpc"
  context    = module.this.context
  cidr_block = var.cidr_block
}

locals {
  public_subnets_list = flatten([for az in keys(var.subnets) : [for name, s in var.subnets[az] : merge({ "name" : name, "az" : az }, s) if s.public_route_enabled]])
  public_subnets      = { for n in local.public_subnets_list : n.name => n }

  private_subnets_list = flatten([for az in keys(var.subnets) : [for name, s in var.subnets[az] : merge({ "name" : name, "az" : az }, s) if ! s.public_route_enabled]])
  private_subnets      = { for n in local.private_subnets_list : n.name => n }
}

# handy security group we export
resource "aws_security_group" "sg_allow_ssh" {
  description = "Allows ingress on port 22 and icmp. Allows full egress."
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.this.tags
}
