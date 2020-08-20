output "arn" {
  value = aws_lambda_function.lambda_func.arn
}
output "qualified_arn" {
  value = aws_lambda_function.lambda_func.qualified_arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda_func.invoke_arn
}
output "version" {
  value = aws_lambda_function.lambda_func.version
}
output "last_modified" {
  value = aws_lambda_function.lambda_func.last_modified
}
