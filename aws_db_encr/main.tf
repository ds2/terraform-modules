data "aws_vpc" "vpc" {
  id = var.vpcId
}

data "aws_subnet" "subnets" {
  for_each = var.subnetGrpIds
  id       = each.value
}

locals {
  mySubnetCidrs  = [for s in data.aws_subnet.subnets : s.cidr_block]
  mySubnetCidrs6 = [for s in data.aws_subnet.subnets : s.ipv6_cidr_block]
}

# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.subnets : s.cidr_block]
# }

resource "aws_db_subnet_group" "sngrp" {
  name_prefix = "${var.name}-db-subnet-grp-"
  subnet_ids  = var.subnetGrpIds
  description = "the db subnet grp for ${var.name}"

  tags = {
    Name        = "${var.name}-db-subnet-grp"
    Terraformed = true
  }
}


resource "aws_security_group" "db-sg1" {
  # name_prefix = "${var.name}-security-group-"
  name_prefix = "${var.name}-security-group-"
  description = "the traffic allowed for ingress and egress of the database for ${var.name}"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.name}-security-group"
    Terraformed = true
  }
}

resource "aws_security_group_rule" "ing1" {
  security_group_id = aws_security_group.db-sg1.id
  type              = "ingress"
  description       = "to access the db"
  from_port         = var.dbPort
  to_port           = var.dbPort
  protocol          = "tcp"
  cidr_blocks       = local.mySubnetCidrs
  ipv6_cidr_blocks  = local.mySubnetCidrs6
}

resource "aws_security_group_rule" "egress1" {
  security_group_id = aws_security_group.db-sg1.id
  type              = "egress"
  description       = "for all outgoing traffic from the db"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.mySubnetCidrs
  ipv6_cidr_blocks  = local.mySubnetCidrs6
}

resource "aws_db_parameter_group" "dbparams" {
  name_prefix = "${var.name}-params-"
  family      = var.paramFamily
  description = "DB Params for ${var.name}"

  dynamic "parameter" {
    for_each = var.dbParams
    content {
      name         = each.key
      value        = each.value
      apply_method = "pending-reboot"
    }
  }

  tags = {
    Name        = var.name
    Terraformed = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "db" {
  identifier_prefix               = "${var.name}-"
  instance_class                  = var.instanceClass
  allocated_storage               = var.storageSize
  max_allocated_storage           = var.storageScaler != null ? var.storageSize + var.storageScaler : null
  storage_type                    = "gp2"
  engine                          = "postgres"
  engine_version                  = var.dbVersion
  port                            = var.dbPort
  allow_major_version_upgrade     = true
  auto_minor_version_upgrade      = true
  name                            = var.dbName
  final_snapshot_identifier       = "${var.name}-final-snapshot"
  copy_tags_to_snapshot           = true
  username                        = var.dbAdminUser
  password                        = var.dbAdminPw
  backup_retention_period         = var.backupRetentionDays
  backup_window                   = "00:10-01:30"
  maintenance_window              = "Wed:01:30-Wed:03:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade", ]
  multi_az                        = var.multiAZ
  db_subnet_group_name            = aws_db_subnet_group.sngrp.name
  publicly_accessible             = false
  storage_encrypted               = var.kmsKeyArn != null ? true : false
  # timezone                        = "Europe/Berlin"
  tags = {
    Terraformed = true
    Name        = var.name
  }
  kms_key_id                          = var.kmsKeyArn
  vpc_security_group_ids              = [aws_security_group.db-sg1.id]
  deletion_protection                 = false
  iam_database_authentication_enabled = false
  parameter_group_name                = aws_db_parameter_group.dbparams.id
  depends_on = [
    aws_security_group.db-sg1
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpuutilalert" {
  alarm_name                = "${var.name}-db-cpu-utilization-high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "The cpu utilization for the db instance ${var.name} is very high. Please check!"
  insufficient_data_actions = []
  dimensions {
    DBInstanceIdentifier = aws_db_instance.db.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "connectionhigh" {
  alarm_name                = "${var.name}-db-connectioncount-high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "DatabaseConnections"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "The connection count for the db instance ${var.name} is very high. Please check!"
  insufficient_data_actions = []
  dimensions {
    DBInstanceIdentifier = aws_db_instance.db.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "freestoragesize" {
  alarm_name                = "${var.name}-db-freestoragesize-low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 1000000
  alarm_description         = "The storage size for the db instance ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  dimensions {
    DBInstanceIdentifier = aws_db_instance.db.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "cpucreditbalance" {
  alarm_name                = "${var.name}-db-cpucreditbalance-low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = 30
  alarm_description         = "The credit balance for the db instance ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  dimensions {
    DBInstanceIdentifier = aws_db_instance.db.arn
  }
}
