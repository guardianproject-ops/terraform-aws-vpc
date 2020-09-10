variable "private_route_table_id" {
  type = string
}

variable "aws_route_create_timeout" {
  type        = string
  default     = "2m"
  description = "Time to wait for AWS route creation specifed as a Go Duration, e.g. `2m`"
}

variable "aws_route_delete_timeout" {
  type        = string
  default     = "5m"
  description = "Time to wait for AWS route deletion specifed as a Go Duration, e.g. `5m`"
}

variable "nat_instance_type" {
  type        = string
  description = "NAT Instance type"
  default     = "t3.micro"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone where instance will be deployed will be created"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "subnet_id" {
  type = string
}
