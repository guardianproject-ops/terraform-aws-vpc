output "id" {
  value = join("", aws_nat_gateway.nat.*.id)
}
output "public_ip" {
  value = join("", aws_eip.nat.*.public_ip)
}
output "eip_id" {
  value = join("", aws_eip.nat.*.id)
}
output "public_subnet_id" {
  value = var.public_subnet_id
}

output "vpc_id" {
  value = var.vpc_id
}
