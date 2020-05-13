output "arn" {
  value = aws_s3_bucket.bucket.arn
}

output "domain" {
  value = aws_s3_bucket.bucket.website_domain
}

output "regionalName" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "bucketPolicy" {
  value = data.aws_iam_policy_document.cdnPolicy.json
}
