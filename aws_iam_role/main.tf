resource "aws_iam_role" "role" {
  assume_role_policy = var.assumeRolePolicy
  description        = var.description != null ? var.description : "the role for ${var.name}"
  name_prefix        = "${var.name}-"
  tags = {
    Terraformed = true
    Name        = var.name
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.name}-policy"
  description = "the policy for ${var.name}"

  policy = var.policyData
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
