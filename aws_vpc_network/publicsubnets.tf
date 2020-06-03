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
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # ipv6_cidr_block="::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    # egress_only_gateway_id = aws_egress_only_internet_gateway.egress_only.id
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "${var.name} public routes"
    Terraformed = true
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.pubroute.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, 0)
  subnet_id     = aws_subnet.public[0].id

  lifecycle { create_before_destroy = true }
  tags = {
    Name        = var.name
    Terraformed = true
  }
  depends_on = [aws_internet_gateway.gw]
}
