output "subnet_id" {
  value = aws_subnet.subnet.id
}


output "route_table_id" {
  value = aws_route_table.subnet.id
}

output "availability_zone" {
  value = var.availability_zone
}
