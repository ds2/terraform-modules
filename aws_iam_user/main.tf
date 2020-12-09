resource "aws_iam_user" "user" {
  name = var.username
  path = var.awsPath

  tags = {
    Terraformed = true
    Name        = var.username
  }
}

resource "aws_iam_access_key" "acckey" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy" "userpolicies" {
  for_each = var.policyArns
  arn      = each.value
}

resource "aws_iam_user_policy_attachment" "attach-roles" {
  for_each   = data.aws_iam_policy.userpolicies
  user       = aws_iam_user.user.name
  policy_arn = each.value.arn
}
