data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  count                     = var.monitorCreditBalance ? 1 : 0
  alarm_name                = "${var.name} Low CPUCreditBalance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.creditBalanceThreshold
  alarm_description         = "The credit balance for the ec2 instance ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = "ignored"
  dimensions = var.dimensions
  tags = {
    Name        = "${var.name} CPU Credit Balance"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpuutil" {
  count                     = var.monitorCreditBalance ? 1 : 0
  alarm_name                = "${var.name} High CPU load"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = var.cpuUsageThreshold
  alarm_description         = "The cpu utilization for the ec2 instance ${var.name} is very high. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = "ignored"
  dimensions = var.dimensions
  tags = {
    Name        = "${var.name} CPU Utilization"
    Terraformed = true
  }
}

locals {
  myInstanceActions = var.availActionArns != null ? var.availActionArns : ["arn:aws:automate:${data.aws_region.current.name}:ec2:reboot"]
}

resource "aws_cloudwatch_metric_alarm" "instance_avail" {
  alarm_name                = "${var.name} available"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.availCheckCount
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = var.availCheckPeriod
  statistic                 = "Average"
  threshold                 = 0.99
  alarm_description         = "We cannot reach instance ${var.name}. Please check!"
  insufficient_data_actions = []
  alarm_actions             = compact(concat(tolist(var.snsTopicArns), tolist(local.myInstanceActions)))
  ok_actions                = var.snsTopicArns
  # treat_missing_data        = "ignored"
  dimensions = var.dimensions
  tags = {
    Name        = "${var.name} Instance available"
    Terraformed = true
  }
}