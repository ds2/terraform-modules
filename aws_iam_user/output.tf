output "arn" {
  value = aws_iam_user.user.arn
}

output "secretkey" {
  value = aws_iam_access_key.acckey.ses_smtp_password_v4
}

output "accesskey" {
  value = aws_iam_access_key.acckey.id
}

output "secret" {
  description = "the secret key of the user"
  value       = aws_iam_access_key.acckey.secret
}
