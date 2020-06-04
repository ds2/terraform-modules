resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  assign_generated_ipv6_cidr_block = var.enableIpv6
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    Terraformed = true
    Name        = var.name
  }
}

resource "aws_egress_only_internet_gateway" "egress_only" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Terraformed = true
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = var.name
    Terraformed = true
  }
}
