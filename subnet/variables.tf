variable "vpc_id" {
  type        = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}
variable "igw_id" {
  type = string
}
variable "subnet_cidr_block" {
  type = string
}
variable "availability_zone" {
  type = string
}
variable "subnet_name" {
  type        = string
  description = "The name of subnet, e.g, public, private, rds"
}
variable "public_route_enabled" {
  type        = bool
  description = "If this subnet is publicly routable"
  default     = false
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
variable "route_table_id" {
  type = string
}
