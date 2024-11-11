
##################
# AWS VPC Module #
##################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  #  domain        = "vpc"
  depends_on = [aws_internet_gateway.ig]
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
}
