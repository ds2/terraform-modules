data "aws_vpc" "vpc" {
  id = var.vpcId
}

data "aws_subnet" "subnets" {
  for_each = var.subnetGrpIds
  id       = each.value
}

data "aws_subnet" "accesssubnets" {
  for_each = var.accessSubnetGrpIds
  id       = each.value
}

locals {
  mySubnetCidrs  = [for s in data.aws_subnet.subnets : s.cidr_block]
  mySubnetCidrs6 = [for s in data.aws_subnet.subnets : s.ipv6_cidr_block if s.ipv6_cidr_block != null]
  access_cidrs   = [for s in data.aws_subnet.accesssubnets : s.cidr_block if s.cidr_block != null]
  access_cidrs6  = [for s in data.aws_subnet.accesssubnets : s.ipv6_cidr_block if s.ipv6_cidr_block != null]
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
  cidr_blocks       = local.access_cidrs
  ipv6_cidr_blocks  = length(local.access_cidrs6) > 0 ? local.access_cidrs6 : null
}

resource "aws_security_group_rule" "egress1" {
  security_group_id = aws_security_group.db-sg1.id
  type              = "egress"
  description       = "for all outgoing traffic from the db"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.access_cidrs
  ipv6_cidr_blocks  = length(local.access_cidrs6) > 0 ? local.access_cidrs6 : null
}

resource "aws_db_parameter_group" "dbparams" {
  name_prefix = "${var.name}-params-"
  family      = var.paramFamily
  description = "DB Params for ${var.name}"

  dynamic "parameter" {
    for_each = var.dbParams
    content {
      name         = parameter.key
      value        = parameter.value
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

module "cw" {
  source        = "../aws_cloudwatch_loggroup"
  name          = "/aws/rds/instance/${var.name}/postgresql"
  retentionDays = var.logfileRetentionDays
  kmsKeyArn     = var.kmsKeyArn
}

resource "aws_db_instance" "db" {
  identifier                      = var.name
  instance_class                  = var.instanceClass
  allocated_storage               = var.storageSize
  max_allocated_storage           = var.maxStorage != null ? var.maxStorage : 3 * var.storageSize
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

module "cw_alerts" {
  source                  = "../aws_rds_cw_alerts"
  dbInstanceId            = aws_db_instance.db.id
  storageBytesThreshold   = var.storageBytesThreshold
  cpuUtilThreshold        = var.cpuUtilThreshold
  monitorCreditBalance    = var.monitorCreditBalance
  highConnectionThreshold = var.highConnectionThreshold
  alarmSnsArns            = var.snsTopicArns
  okSnsArns               = var.snsTopicArns
  insufficientSnsArns     = var.snsTopicArns
}
