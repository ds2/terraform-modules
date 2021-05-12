data "aws_db_instance" "db" {
  db_instance_identifier = var.dbInstanceId
}

resource "aws_cloudwatch_metric_alarm" "cpuutilalert" {
  alarm_name                = "${data.aws_db_instance.db.db_instance_identifier} High CPU Usage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.cpuUtilThreshold
  alarm_description         = "The cpu utilization for the db instance ${data.aws_db_instance.db.db_instance_identifier} is very high. Please check!"
  insufficient_data_actions = var.insufficientSnsArns
  alarm_actions             = var.alarmSnsArns
  ok_actions                = var.okSnsArns
  treat_missing_data        = var.missingData
  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.db.db_instance_identifier
  }
  tags = {
    Name        = "${data.aws_db_instance.db.db_instance_identifier} CPU Utilization"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "connectionhigh" {
  alarm_name                = "${data.aws_db_instance.db.db_instance_identifier} High Connection Count"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.highConnectionThreshold
  alarm_description         = "The connection count for the db instance ${data.aws_db_instance.db.db_instance_identifier} is very high. Please check!"
  insufficient_data_actions = var.insufficientSnsArns
  alarm_actions             = var.alarmSnsArns
  ok_actions                = var.okSnsArns
  treat_missing_data        = var.missingData
  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.db.db_instance_identifier
  }
  tags = {
    Name        = "${data.aws_db_instance.db.db_instance_identifier} Connection High"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "freestoragesize" {
  alarm_name                = "${data.aws_db_instance.db.db_instance_identifier} Storage Low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.storageBytesThreshold
  alarm_description         = "The storage size for the db instance ${data.aws_db_instance.db.db_instance_identifier} is very low. Please check!"
  insufficient_data_actions = var.insufficientSnsArns
  alarm_actions             = var.alarmSnsArns
  ok_actions                = var.okSnsArns
  treat_missing_data        = var.missingData
  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.db.db_instance_identifier
  }
  tags = {
    Name        = "${data.aws_db_instance.db.db_instance_identifier} Free Storage"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  count                     = var.monitorCreditBalance ? 1 : 0
  alarm_name                = "${data.aws_db_instance.db.db_instance_identifier} Low CPUCreditBalance"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "The credit balance for the db instance ${data.aws_db_instance.db.db_instance_identifier} is very low. Please check!"
  insufficient_data_actions = var.insufficientSnsArns
  alarm_actions             = var.alarmSnsArns
  ok_actions                = var.okSnsArns
  treat_missing_data        = var.missingData
  dimensions = {
    DBInstanceIdentifier = data.aws_db_instance.db.db_instance_identifier
  }
  tags = {
    Name        = "${data.aws_db_instance.db.db_instance_identifier} CPU Credit Balance"
    Terraformed = true
  }
}
