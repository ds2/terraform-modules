resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = var.acl
  region = var.region

  tags = {
    Name         = var.name
    Terraformed  = true
    s3BucketName = var.name
  }
  versioning {
    enabled = var.versioned
  }

  lifecycle_rule {
    id = "agingOutdatedVersions"

    # prefix  = "config/"
    enabled = var.versioned

    abort_incomplete_multipart_upload_days = var.maxUploadDays

    noncurrent_version_transition {
      days          = var.ncvDays
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = var.ncvExpireDays
    }
  }
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  dynamic "website" {
    for_each = var.isWebsite ? [1] : []
    content {
      index_document           = var.websiteRedirectAllTo != null ? null : var.websiteIndexFile
      error_document           = var.websiteRedirectAllTo != null ? null : var.websiteErrorFile
      redirect_all_requests_to = var.websiteRedirectAllTo
      routing_rules            = var.websiteRoutingRulesJson
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.encryptContent ? [1] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = var.kmsKeyArn != null ? var.kmsKeyArn : null
          sse_algorithm     = var.kmsKeyArn != null ? "aws:kms" : "AES256"
        }
      }
    }
  }
}

data "aws_iam_policy_document" "cdnPolicy" {
  dynamic "statement" {
    for_each = var.readonlyIamArn
    content {
      sid     = "readPerms"
      actions = var.readPermissions
      resources = [
        "${aws_s3_bucket.bucket.arn}/*",
        aws_s3_bucket.bucket.arn
      ]

      principals {
        type        = "AWS"
        identifiers = var.readonlyIamArn
      }
    }
  }
  dynamic "statement" {
    for_each = var.adminIamArn
    content {
      sid     = "adminPerms"
      actions = var.adminPermissions
      resources = [
        "${aws_s3_bucket.bucket.arn}/*",
        aws_s3_bucket.bucket.arn
      ]

      principals {
        type        = "AWS"
        identifiers = var.adminIamArn
      }
    }
  }

}

locals {
  allCounts = length(var.readonlyIamArn) + length(var.adminIamArn)
}

resource "aws_s3_bucket_policy" "policy" {
  count  = local.allCounts > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.cdnPolicy.json
}
