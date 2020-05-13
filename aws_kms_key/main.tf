data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "keypolicy" {
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        data.aws_caller_identity.current.arn
      ]
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
  name          = var.aliasName != null && var.aliasPrefix == null ? "alias/${var.aliasName}" : null
  name_prefix   = var.aliasPrefix != null ? "alias/${var.aliasPrefix}-" : null
  target_key_id = aws_kms_key.key.key_id
}
