module "nat_instance_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["nat", "instance"]
  context    = module.this.context
}


resource "aws_security_group" "nat_instance" {
  count = var.enabled ? 1 : 0

  name        = module.nat_instance_label.id
  description = "Security Group for NAT Instance"
  vpc_id      = var.vpc_id
  tags        = module.nat_instance_label.tags
}

resource "aws_security_group_rule" "nat_instance_egress" {
  count = var.enabled ? 1 : 0

  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance[0].id
  type              = "egress"
}

resource "aws_security_group_rule" "nat_instance_ingress" {
  count = var.enabled ? 1 : 0

  description       = "Allow ingress traffic from the VPC CIDR block"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.nat_instance[0].id
  type              = "ingress"
}

// aws --region us-west-2 ec2 describe-images --owners amazon --filters Name="name",Values="amzn-ami-vpc-nat*" Name="virtualization-type",Values="hvm"
data "aws_ami" "nat_instance" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# create an SSM-enabled EC2 instance profile
data "aws_iam_policy_document" "assume_ec2_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm" {
  count              = var.enabled ? 1 : 0
  name               = module.nat_instance_label.id
  assume_role_policy = data.aws_iam_policy_document.assume_ec2_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.ssm[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ssm" {
  count = var.enabled ? 1 : 0
  name  = module.nat_instance_label.id
  role  = aws_iam_role.ssm[0].name
}

// https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html
// https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html
// https://dzone.com/articles/nat-instance-vs-nat-gateway
resource "aws_instance" "nat_instance" {
  count                  = var.enabled ? 1 : 0
  ami                    = data.aws_ami.nat_instance.id
  instance_type          = var.nat_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.nat_instance[0].id]
  iam_instance_profile   = aws_iam_instance_profile.ssm[0].id

  tags = merge(
    module.nat_instance_label.tags,
    { "Application" : "nat-instance" }
  )

  # Required by NAT
  # https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#EIP_Disable_SrcDestCheck
  source_dest_check = false

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["ami"]
  }
}

resource "aws_eip" "nat_instance" {
  count = var.enabled ? 1 : 0

  vpc  = true
  tags = module.nat_instance_label.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip_association" "nat_instance" {
  count = var.enabled ? 1 : 0

  instance_id   = aws_instance.nat_instance[0].id
  allocation_id = aws_eip.nat_instance[0].id
}

resource "aws_route" "nat_instance" {
  count = var.enabled ? 1 : 0

  route_table_id         = var.private_route_table_id
  instance_id            = aws_instance.nat_instance[0].id
  destination_cidr_block = "0.0.0.0/0"

  timeouts {
    create = var.aws_route_create_timeout
    delete = var.aws_route_delete_timeout
  }
}
