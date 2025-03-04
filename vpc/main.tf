module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  context = module.this.context
}

resource "aws_vpc" "default" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = true
  tags                             = module.label.tags
}

# If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(module.label.tags, { Name = "Default Security Group" })
}

resource "aws_internet_gateway" "default" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.default.id
  tags   = module.label.tags
}
