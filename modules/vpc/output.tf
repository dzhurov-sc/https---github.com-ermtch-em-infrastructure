
###################################
# Output Variables for VPC module #
###################################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zones" {
  value = var.availability_zones
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnet.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnet.*.id
}

output "eni_public_ip" {
  value = aws_eip.nat_eip.public_ip
}

output "ecs_sg_id" {
  value = aws_security_group.ecs.id
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}