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
