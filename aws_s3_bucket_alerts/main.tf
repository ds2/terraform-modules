data "aws_s3_bucket" "bucket" {
  bucket = var.s3BucketName
}

resource "aws_cloudwatch_metric_alarm" "bucketsize" {
  alarm_name                = "S3 ${data.aws_s3_bucket.bucket.id} size"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "BucketSizeBytes"
  namespace                 = "AWS/S3"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = var.sizeThreshold
  alarm_description         = "The size of this bucket exceeds the threshold! Please check!! Maybe increasing the threshold makes sense?"
  insufficient_data_actions = var.snsNoDataArns
  alarm_actions             = var.snsAlarmArns
  ok_actions                = var.snsOkArns
  actions_enabled           = var.enabled
  treat_missing_data        = "notBreaching"
  dimensions = {
    BucketName  = data.aws_s3_bucket.bucket.id
    StorageType = "StandardStorage"
  }
  tags = {
    Name        = "S3 ${data.aws_s3_bucket.bucket.id} size"
    Terraformed = true
  }
}

resource "aws_cloudwatch_metric_alarm" "objectcount" {
  alarm_name                = "S3 ${data.aws_s3_bucket.bucket.id} too many objects"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "NumberOfObjects"
  namespace                 = "AWS/S3"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = var.objectCountThreshold
  alarm_description         = "There are too many objects in this bucket. Maybe you want to delete some of them?"
  insufficient_data_actions = var.snsNoDataArns
  alarm_actions             = var.snsAlarmArns
  ok_actions                = var.snsOkArns
  actions_enabled           = var.enabled
  treat_missing_data        = "notBreaching"
  dimensions = {
    BucketName  = data.aws_s3_bucket.bucket.id
    StorageType = "StandardStorage"
  }
  tags = {
    Name        = "S3 ${data.aws_s3_bucket.bucket.id} too many objects"
    Terraformed = true
  }
}
