resource "aws_iam_role" "role" {
  assume_role_policy   = var.assumeRolePolicy
  description          = var.description != null ? var.description : "the role for ${var.name}"
  name_prefix          = var.useNameNotPrefix ? null : "${var.name}-"
  name                 = var.useNameNotPrefix ? var.name : null
  path                 = var.rolePath
  max_session_duration = var.maxSessionSeconds
  tags = {
    Terraformed = true
    Name        = var.name
  }
  lifecycle {
    ignore_changes = [managed_policy_arns] # for some reason, AWS creates its own policy and attaches it to this role. So, we ignore this afterwards ;)
  }
}

resource "aws_iam_policy" "userpolicy" {
  count       = var.policyData != null ? 1 : 0
  name_prefix = "${var.name}-policy-"
  description = "the user shipped policy for ${var.name}"
  policy      = var.policyData
}
resource "aws_iam_role_policy_attachment" "user-attach" {
  count      = var.policyData != null ? 1 : 0
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.userpolicy[0].arn
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  count      = length(var.policyArns)
  role       = aws_iam_role.role.name
  policy_arn = var.policyArns[count.index]
}
