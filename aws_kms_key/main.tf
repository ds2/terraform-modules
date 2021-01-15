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
