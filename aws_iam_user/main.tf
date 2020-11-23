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

resource "aws_iam_user_policy_attachment" "attach-roles" {
  for_each   = var.policyArns
  user       = aws_iam_user.user.name
  policy_arn = each.value
}
