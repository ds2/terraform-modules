data "aws_ami" "img" {
  most_recent = true

  filter {
    name   = "name"
    values = var.imgNames
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = var.owners
}

data "aws_subnet" "subnet" {
  id = var.subnetId
}

resource "aws_security_group" "sg" {
  name_prefix = "${var.name}-"
  description = "specifies traffic for the bastion node ${var.name}"
  vpc_id      = data.aws_subnet.subnet.vpc_id
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

resource "aws_security_group_rule" "ingress1" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  description       = "to access the node via ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "ingress2" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  description       = "to access the node via mosh"
  from_port         = 60000
  to_port           = 60100
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "egress1" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  description       = "for all outgoing traffic from the bastion node"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

module "ec2" {
  source = "../aws_ec2_instance"
  name   = var.name
  # allowedExternalTcpPorts = [22]
  # allowedExternalUdpPorts = [60000, 60001, 60002, 60003]
  amiId            = data.aws_ami.img.id
  instanceType     = var.instanceType
  sshKeyName       = var.sshKeyName
  isPublic         = true
  subnetId      = var.subnetId
  volumeSize       = 10
  securityGroupIds = [aws_security_group.sg.id]
}
