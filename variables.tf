variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "subnets" {
  description = "A list of maps describing the subnets to create."
  type = list(object({
    type                 = string
    availability_zone    = string
    cidr_block           = string
    public_route_enabled = bool
    nat_instance_enabled = bool
    nat_gateway_enabled  = bool
  }))
}

variable "nat_instance_type" {
  type        = string
  description = "NAT Instance type"
  default     = "t3.micro"
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
