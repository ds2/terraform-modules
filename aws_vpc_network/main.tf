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

resource "aws_network_acl" "acl" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = concat(aws_subnet.public.*.id,aws_subnet.private.*.id)

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    # ipv6_cidr_block="::/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "-1"
    rule_no    = 110
    action     = "allow"
    ipv6_cidr_block="::/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    # ipv6_cidr_block="::/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = "-1"
    rule_no    = 110
    action     = "allow"
    ipv6_cidr_block="::/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.name}-all"
    Terraformed = true
  }
}
