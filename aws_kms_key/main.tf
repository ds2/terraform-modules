data "aws_caller_identity" "current" {}

locals {
  keyPeople = tolist([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    data.aws_caller_identity.current.arn
  ])
}

data "aws_iam_policy_document" "keypolicy" {
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = sort(distinct(compact(concat(local.keyPeople, tolist(var.adminArns)))))
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "2"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
    actions   = ["kms:Encrypt", "kms:Decrypt"]
    resources = ["*"]
  }
  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    actions   = ["kms:GenerateDataKey*"]
    effect    = "Allow"
    resources = ["*"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
  statement {
    sid       = "Allow CloudTrail to describe key"
    actions   = ["kms:DescribeKey"]
    effect    = "Allow"
    resources = ["*"]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
  statement {
    sid = "Allow principals in the account to decrypt log files"
    actions = ["kms:Decrypt",
    "kms:ReEncryptFrom"]
    effect    = "Allow"
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
    }
  }
  statement {
    sid       = "Allow alias creation during setup"
    actions   = ["kms:CreateAlias"]
    effect    = "Allow"
    resources = ["*"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.eu-central-1.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_kms_key" "key" {
  description              = var.descr
  deletion_window_in_days  = var.deletionDays
  is_enabled               = var.enabled
  policy                   = data.aws_iam_policy_document.keypolicy.json
  enable_key_rotation      = var.keyRotation
  key_usage                = var.keyUsage
  customer_master_key_spec = var.keySpec
  tags = {
    Terraformed = true
    Name        = var.name
  }
}

resource "aws_kms_alias" "alias" {
  name          = var.usePrefix ? null : "alias/${var.name}"
  name_prefix   = var.usePrefix ? "alias/${var.name}" : null
  target_key_id = aws_kms_key.key.key_id
}
