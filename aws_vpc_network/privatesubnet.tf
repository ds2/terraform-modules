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


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.enableNatGateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_only.id
  }
  tags = {
    Name        = "${var.name} private routes"
    Terraformed = true
  }
  lifecycle { create_before_destroy = true }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}



resource "aws_network_acl" "privacl" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = concat(aws_subnet.private.*.id)

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    # ipv6_cidr_block="::/0"
    from_port = 0
    to_port   = 0
  }
  ingress {
    protocol        = "-1"
    rule_no         = 110
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    # ipv6_cidr_block="::/0"
    from_port = 0
    to_port   = 0
  }
  egress {
    protocol        = "-1"
    rule_no         = 110
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
  }

  tags = {
    Name        = "${var.name}-private-acl"
    Terraformed = true
  }
}
