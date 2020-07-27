resource "aws_cloudwatch_log_group" "loggroup" {
  name_prefix       = var.prefix
  name              = var.name
  retention_in_days = var.retentionDays
  kms_key_id        = var.kmsKeyArn
  tags = {
    Name        = var.prefix == null ? var.name : var.prefix
    Terraformed = true
  }
}
