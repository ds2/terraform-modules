output "arn" {
  value = aws_iam_role.role != null ? aws_iam_role.role.arn : null
}

output "name" {
  value = aws_iam_role.role != null ? aws_iam_role.role.name : null
}

output "unique_id" {
  value = aws_iam_role.role != null ? aws_iam_role.role.unique_id : null
}

output "id" {
  value = aws_iam_role.role != null ? aws_iam_role.role.id : null
}
