data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy_one" {
  name_prefix = "${var.id}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${module.loggroup.name}:log-stream:${data.aws_caller_identity.current.account_id}_CloudTrail_${data.aws_region.current.name}*"
      },
    ]
  })
}

resource "aws_iam_role" "role" {
  name_prefix         = "${var.id}-role"
  assume_role_policy  = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [aws_iam_policy.policy_one.arn]
  tags = {
    Terraformed = true
    Name        = var.id
  }
  lifecycle {
    ignore_changes = [managed_policy_arns] # for some reason, AWS creates its own policy and attaches it to this role. So, we ignore this afterwards ;)
  }
}
