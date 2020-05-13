data "aws_vpc" "vpc" {
  id = var.vpcId
}

data "aws_subnet" "subnets" {
  for_each = toset(var.subnetGrpIds)
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
  depends_on = [
    aws_security_group.db-sg1
  ]
}
