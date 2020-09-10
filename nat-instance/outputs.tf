output "id" {
  value = join("", aws_instance.nat_instance.*.id)
}
output "public_ip" {
  value = join("", aws_eip.nat_instance.*.public_ip)
}
output "eip_id" {
  value = join("", aws_eip.nat_instance.*.id)
}

output "availability_zone" {
  value = var.availability_zone
}

output "subnet_id" {
  value = var.subnet_id
}

output "vpc_id" {
  value = var.vpc_id
}
