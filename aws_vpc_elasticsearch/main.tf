data "aws_vpc" "selected" {
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

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "es_sg" {
  name_prefix = "${var.name}-elasticsearch-"
  description = "The SG for Elasticsearch ${var.name}"
  vpc_id      = var.vpcId

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    description      = "allow https port 443 from known subnets"
    cidr_blocks      = local.access_cidrs
    ipv6_cidr_blocks = length(local.access_cidrs6) > 0 ? local.access_cidrs6 : null
  }
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
  description      = "Linked role for ES ${var.name}"
  custom_suffix    = var.roleSuffix
}

module "loggroup" {
  source        = "../aws_cloudwatch_loggroup"
  prefix        = var.name
  retentionDays = 365
  kmsKeyArn     = var.kmsKeyArn
}

resource "aws_cloudwatch_log_resource_policy" "policy" {
  policy_name = var.name

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_elasticsearch_domain" "domain" {
  domain_name           = var.name
  elasticsearch_version = var.esVersion

  cluster_config {
    instance_type            = var.instanceType
    instance_count           = var.instanceCount
    dedicated_master_enabled = var.masterCount > 0
    dedicated_master_type    = var.masterInstanceType
    dedicated_master_count   = var.masterCount
    zone_awareness_enabled   = var.zoneAware
  }
  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kmsKeyArn
  }

  vpc_options {
    subnet_ids         = var.subnetGrpIds
    security_group_ids = [aws_security_group.es_sg.id]
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshotStartHourUtc
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  tags = {
    Domain      = var.name
    Name        = var.name
    Terraformed = true
  }
  dynamic "log_publishing_options" {
    for_each = var.logTypes
    iterator = it
    content {
      cloudwatch_log_group_arn = module.loggroup.arn
      log_type                 = it.key
    }
  }
  ebs_options {
    ebs_enabled = true
    volume_size = var.volumeSize
    # volume_type="gp2"
  }

  depends_on = [
    aws_iam_service_linked_role.es,
  ]
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid     = "allowAll"
    actions = ["es:*"]
    effect  = "Allow"
    dynamic "principals" {
      for_each = length(var.adminArns) > 0 ? [1] : []
      content {
        type = "AWS"
        identifiers = compact(coalesce(
          var.adminArns,
          [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn
          ]
        ))
      }
    }
    resources = ["${aws_elasticsearch_domain.domain.arn}/*"]
  }
  statement {
    sid = "writeUsers"
    actions = [
      "es:ESHttpGet",
      "es:ESHttpPut",
      "es:ESHttpHead",
      "es:ESHttpDelete",
      "es:ESHttpPatch",
      "es:ESHttpPost"
    ]
    effect = "Allow"
    dynamic "principals" {
      for_each = length(var.writeArns) > 0 ? [1] : []
      content {
        type = "AWS"
        identifiers = compact(coalesce(
          var.writeArns,
          [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn
          ]
        ))
      }
    }
    resources = ["${aws_elasticsearch_domain.domain.arn}/*"]
  }
  statement {
    sid = "readAll"
    actions = [
      "es:Describe*",
      "es:List*",
      "es:ESHttpHead",
      "es:ESHttpGet"
    ]
    effect = "Allow"
    dynamic "principals" {
      for_each = length(var.readArns) > 0 ? [1] : []
      content {
        type = "AWS"
        identifiers = compact(coalesce(
          var.readArns,
          [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            data.aws_caller_identity.current.arn
          ]
        ))
      }
    }
    resources = ["${aws_elasticsearch_domain.domain.arn}/logstash-*"]
  }
}

resource "aws_elasticsearch_domain_policy" "main" {
  domain_name     = aws_elasticsearch_domain.domain.domain_name
  access_policies = data.aws_iam_policy_document.policy.json
}

resource "aws_cloudwatch_metric_alarm" "freestoragesize" {
  alarm_name                = "${var.name} Storage Low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/ES"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = var.storageBytesThreshold
  alarm_description         = "The storage size for the elasticsearch instance ${var.name} is very low. Please check!"
  insufficient_data_actions = []
  alarm_actions             = var.snsTopicArns
  ok_actions                = var.snsTopicArns
  treat_missing_data        = var.missingData
  dimensions = {
    DomainName = var.name
  }
  tags = {
    Name        = "${var.name} Free Storage"
    Terraformed = true
  }
}
