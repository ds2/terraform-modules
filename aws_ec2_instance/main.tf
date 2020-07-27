data "aws_subnet" "subnet" {
  id = var.subnetId
}

resource "aws_security_group" "extsg" {
  name_prefix = "${var.name}-"
  description = "specifies external traffic for the node ${var.name}"
  vpc_id      = data.aws_subnet.subnet.vpc_id
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

locals {
  extTcpPortList = tolist(var.allowedExternalTcpPorts)
  extUdpPortList = tolist(var.allowedExternalUdpPorts)
}

resource "aws_security_group_rule" "extingress" {
  count             = length(local.extTcpPortList)
  security_group_id = aws_security_group.extsg.id
  type              = "ingress"
  description       = "to access the node via port ${local.extTcpPortList[count.index]}"
  from_port         = local.extTcpPortList[count.index]
  to_port           = local.extTcpPortList[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "extingressudp" {
  count             = length(local.extUdpPortList)
  security_group_id = aws_security_group.extsg.id
  type              = "ingress"
  description       = "to access the node via port udp ${local.extTcpPortList[count.index]}"
  from_port         = local.extUdpPortList[count.index]
  to_port           = local.extUdpPortList[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "extegress" {
  security_group_id = aws_security_group.extsg.id
  type              = "egress"
  description       = "for all outgoing traffic from the bastion node"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
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

  volume_tags = {
    Name        = var.name
    Terraformed = false
    AwsCreated  = true
  }
  lifecycle {
    ignore_changes = [
      tags, ami
    ]
  }
}

resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  count                     = var.monitorCreditBalance ? 1 : 0
  alarm_name                = "${var.name} Low CPUCreditBalance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 10
  alarm_description         = "The credit balance for the ec2 instance ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = "ignored"
  dimensions = {
    InstanceId = aws_instance.instance.id
  }
  tags = {
    Name        = "${var.name} CPU Credit Balance"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpuutil" {
  alarm_name                = "${var.name} High CPU load"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "The cpu utilization for the ec2 instance ${var.name} is very high. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = "ignored"
  dimensions = {
    InstanceId = aws_instance.instance.id
  }
  tags = {
    Name        = "${var.name} CPU Utilization"
    Terraformed = true
  }
}

data "aws_route53_zone" "dnszone" {
  count = var.dnsDomain != null ? 1 : 0
  name  = var.dnsDomain
}

locals {
  pubDnsName       = coalesce(var.dnsName, var.name)
  privDnsName      = format("%s%s", local.pubDnsName, var.dnsInternalNamePostfix)
  hasDnsDomain     = var.dnsDomain != null
  canPubDnsRecord  = local.hasDnsDomain && var.isPublic
  canPrivDnsRecord = local.hasDnsDomain
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
