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

module "iamrole" {
  source           = "../aws_iam_role"
  name             = "${var.id}-role"
  description      = "The role to use for writing data to cloudwatch from cloudtrail"
  assumeRolePolicy = data.aws_iam_policy_document.instance-assume-role-policy.json
  policyArns       = [aws_iam_policy.policy_one.arn]
}
