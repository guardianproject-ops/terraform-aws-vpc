variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "availability_zones" {
  type        = list(string)
  description = "The availability zones to create resources in"
}

variable "nat_gateways" {
  type        = map(string)
  description = "Map where key is the AZ and value is the name of the subnet in which to place a NAT Gateway in this AZ."
}

variable "nat_instances" {
  type        = map(string)
  description = "Map where key is the AZ and value is the name of the subnet in which to place a NAT Instance in this AZ."
}

variable "subnets" {
  description = "A list of maps describing the subnets to create."
  type = map(map(object({
    cidr_block           = string
    public_route_enabled = bool
  })))
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
