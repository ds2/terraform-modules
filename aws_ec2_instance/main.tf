data "aws_subnet" "subnet" {
  id = var.subnetId
}

data "aws_region" "current" {}

data "aws_vpc" "thisvpc" {
  id = data.aws_subnet.subnet.vpc_id
}

resource "aws_security_group" "extsg" {
  name_prefix = "${var.name}-"
  description = "specifies firewall rules for the node ${var.name}"
  vpc_id      = data.aws_subnet.subnet.vpc_id
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

locals {
  extTcpPortList = tolist(var.allowedExternalTcpPorts)
  extUdpPortList = tolist(var.allowedExternalUdpPorts)
  vpcTcpPortList = tolist(var.allowedVpcTcpPorts)
  access_cidrs6  = data.aws_vpc.thisvpc.ipv6_cidr_block != null ? tolist([data.aws_vpc.thisvpc.ipv6_cidr_block]) : []
  egressTcpPorts = tolist(var.allowedEgressTcpPorts)
}

resource "aws_security_group_rule" "extingress" {
  count             = length(local.extTcpPortList)
  security_group_id = aws_security_group.extsg.id
  type              = "ingress"
  description       = "to access the node ${var.name} via port ${local.extTcpPortList[count.index]}"
  from_port         = local.extTcpPortList[count.index]
  to_port           = local.extTcpPortList[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "vpcingress" {
  count             = length(local.vpcTcpPortList)
  security_group_id = aws_security_group.extsg.id
  type              = "ingress"
  description       = "to access the node ${var.name} from vpc via port ${local.vpcTcpPortList[count.index]}"
  from_port         = local.vpcTcpPortList[count.index]
  to_port           = local.vpcTcpPortList[count.index]
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.thisvpc.cidr_block]
  ipv6_cidr_blocks  = length(local.access_cidrs6) > 0 ? local.access_cidrs6 : null
}

resource "aws_security_group_rule" "extingressudp" {
  count             = length(local.extUdpPortList)
  security_group_id = aws_security_group.extsg.id
  type              = "ingress"
  description       = "to access the node via port udp ${local.extTcpPortList[count.index]}"
  from_port         = local.extUdpPortList[count.index]
  to_port           = local.extUdpPortList[count.index]
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "extegress" {
  count             = var.allowUnsecureEgress ? 1 : 0
  security_group_id = aws_security_group.extsg.id
  type              = "egress"
  description       = "for all outgoing traffic from this node ${var.name}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "extegressport" {
  count             = length(local.egressTcpPorts)
  security_group_id = aws_security_group.extsg.id
  type              = "egress"
  description       = "for all outgoing traffic from this node ${var.name} to port ${local.egressTcpPorts[count.index]}"
  from_port         = local.egressTcpPorts[count.index]
  to_port           = local.egressTcpPorts[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_instance" "instance" {
  ami                         = var.amiId
  instance_type               = var.instanceType
  key_name                    = var.sshKeyName
  vpc_security_group_ids      = compact(concat(tolist(var.securityGroupIds), [aws_security_group.extsg.id]))
  subnet_id                   = var.subnetId
  associate_public_ip_address = var.isPublic

  root_block_device {
    volume_size           = var.volumeSize
    encrypted             = true
    kms_key_id            = var.kmsKeyArn
    delete_on_termination = true
  }

  tags = {
    Name        = var.name
    Terraformed = true
  }

  credit_specification {
    cpu_credits = var.unlimitedCpuCredits ? "unlimited" : "standard"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

module "monitoring" {
  source = "../aws_instance_alerts"
  name   = var.name
  dimensions = {
    InstanceId = aws_instance.instance.id
  }
  snsTopicArns           = var.snsTopicArns
  creditUsageThreshold   = var.creditUsageThreshold
  creditBalanceThreshold = var.creditBalanceThreshold
}

data "aws_route53_zone" "dnszone" {
  count = var.dnsDomain != null ? 1 : 0
  name  = var.dnsDomain
}

locals {
  pubDnsName        = coalesce(var.dnsName, var.name)
  privDnsName       = format("%s%s", local.pubDnsName, var.dnsInternalNamePostfix)
  hasDnsDomain      = var.dnsDomain != null
  canPubDnsRecord   = local.hasDnsDomain && var.isPublic
  canPrivDnsRecord  = local.hasDnsDomain
  myInstanceActions = var.availActionArns != null ? var.availActionArns : ["arn:aws:automate:${data.aws_region.current.name}:ec2:reboot"]
}

resource "aws_route53_record" "pubdnsrecord" {
  count      = local.canPubDnsRecord ? 1 : 0
  zone_id    = data.aws_route53_zone.dnszone[0].zone_id
  name       = local.pubDnsName
  type       = "A"
  ttl        = "300"
  records    = [aws_instance.instance.public_ip]
  depends_on = [aws_instance.instance, data.aws_route53_zone.dnszone]
}

resource "aws_route53_record" "privdnsrecord" {
  count      = local.canPrivDnsRecord ? 1 : 0
  zone_id    = data.aws_route53_zone.dnszone[0].zone_id
  name       = local.privDnsName
  type       = "A"
  ttl        = "300"
  records    = [aws_instance.instance.private_ip]
  depends_on = [aws_instance.instance, data.aws_route53_zone.dnszone]
}

resource "aws_ebs_volume" "swap" {
  count             = var.swapSize > 0 ? 1 : 0
  availability_zone = aws_instance.instance.availability_zone
  encrypted         = var.kmsKeyArn != null
  size              = var.swapSize
  kms_key_id        = var.kmsKeyArn

  tags = {
    Name        = "${var.name}-swap"
    Terraformed = true
  }
}

resource "aws_volume_attachment" "swap_attach" {
  count       = var.swapSize > 0 ? 1 : 0
  device_name = var.swapDevName
  volume_id   = aws_ebs_volume.swap[0].id
  instance_id = aws_instance.instance.id
}
