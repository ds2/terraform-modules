data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "logbucket" {
  source    = "../aws_s3_bucket"
  name      = var.s3LogBucketName
  versioned = false
  kmsKeyArn = var.logKmsKeyArn
  policy    = data.aws_iam_policy_document.bucketpolicy.json
}

module "loggroup" {
  source    = "../aws_cloudwatch_loggroup"
  kmsKeyArn = var.logKmsKeyArn
  prefix    = var.id
}

resource "aws_cloudtrail" "trail" {
  name                       = var.id
  s3_bucket_name             = module.logbucket.id
  s3_key_prefix              = var.logPrefix
  is_multi_region_trail      = var.multiRegion
  kms_key_id                 = var.logKmsKeyArn
  cloud_watch_logs_group_arn = "${module.loggroup.arn}:*" # logstream wildcard
  cloud_watch_logs_role_arn  = module.iamrole.arn
  tags = {
    Name        = var.id
    Terraformed = true
  }
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}
