resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  assign_generated_ipv6_cidr_block = var.enableIpv6
  tags = {
    Terraformed = true
    Name        = var.name
  }
}

resource "aws_egress_only_internet_gateway" "egress_only" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private" {
  count                           = length(var.availZones)
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone               = var.availZones[count.index]
  map_public_ip_on_launch         = false
  ipv6_cidr_block                 = var.enableIpv6 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index + 1) : null
  assign_ipv6_address_on_creation = var.enableIpv6
  tags = {
    Terraformed = true
    Name        = "${var.name}-private-${count.index}"
  }
  # lifecycle { create_before_destroy = true }
  depends_on = [aws_vpc.vpc]
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_subnet" "public" {
  count                           = length(var.availZones)
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 10)
  availability_zone               = var.availZones[count.index]
  map_public_ip_on_launch         = true
  ipv6_cidr_block                 = var.enableIpv6 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, count.index + 10) : null
  assign_ipv6_address_on_creation = var.enableIpv6
  tags = {
    Terraformed = true
    Name        = "${var.name}-public-${count.index}"
  }
  # lifecycle { create_before_destroy = true }
  depends_on = [aws_vpc.vpc]
}
