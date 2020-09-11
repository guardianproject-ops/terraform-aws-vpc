output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "availability_zone" {
  value = var.availability_zone
}
