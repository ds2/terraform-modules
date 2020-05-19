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
}

data "template_file" "policy_template" {
  template = var.templateData
}

resource "aws_iam_policy" "policy" {
  name_prefix = "${var.name}-policy-"
  description = "the policy for ${var.name}"

  policy = var.templateData != null ? data.template_file.policy_template.rendered : var.policyData
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
