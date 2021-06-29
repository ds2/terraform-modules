output "arn" {
  value = aws_cloudtrail.trail.arn
}

output "logGroupName" {
  value = module.loggroup.name
}

output "s3BucketArn" {
  value = module.logbucket.arn
}

output "s3BucketName" {
  value = module.logbucket.id
}
