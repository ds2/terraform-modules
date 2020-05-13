resource "aws_iam_role" "role" {
  assume_role_policy = var.assumeRolePolicy
  description        = "the role for ${var.roleName}"
  name_prefix        = "${var.roleName}-"
  tags = {
    Terraformed = true
    Name        = var.roleName
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.roleName}-policy"
  description = "the policy for ${var.roleName}"

  policy = var.policyData
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
