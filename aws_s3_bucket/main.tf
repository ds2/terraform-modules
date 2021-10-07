resource "aws_s3_bucket" "bucket" {
  bucket        = var.name
  acl           = var.acl
  force_destroy = true

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

    prefix  = var.versionObjPrefix
    enabled = var.versioned

    # tags = {
    #   Name         = var.name
    #   rule         = "agingOutdatedVersions"
    #   Terraformed  = true
    #   s3BucketName = var.name
    #   autoclean    = "true"
    # }

    noncurrent_version_transition {
      days          = var.oneZoneDays
      storage_class = "GLACIER"
    }
    noncurrent_version_transition {
      days          = var.oneZoneDays + 90
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      days = var.oneZoneDays + 120
    }
    expiration {
      days                         = var.delCurrObjAfterDays
      expired_object_delete_marker = true
    }
  }

  lifecycle_rule {
    id = "agingCurrentVersions"

    prefix  = var.versionObjPrefix
    enabled = var.enableCurrVersionAging

    tags = {
      rule         = "agingCurrentVersions"
      autoclean    = "true"
      Terraformed  = true
      s3BucketName = var.name
    }

    transition {
      days          = var.oneZoneDays
      storage_class = "ONEZONE_IA"
    }
    transition {
      days          = var.glacierDays
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "deleteAfterDays"
    enabled = var.delCurrObjAfterDays > 0 && !var.versioned
    prefix  = var.delObjPrefix

    expiration {
      days                         = var.delCurrObjAfterDays
      expired_object_delete_marker = true
    }
  }

  lifecycle_rule {
    id                                     = "removeIncompleteUploads"
    enabled                                = var.maxUploadDays > 0
    abort_incomplete_multipart_upload_days = var.maxUploadDays
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
  policy_id = "${var.name}-cdn-policy"
  version   = "2012-10-17"
  dynamic "statement" {
    for_each = var.readonlyIamArn
    content {
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
  count  = local.allCounts > 0 || length(var.policy) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = length(var.policy) > 0 ? var.policy : data.aws_iam_policy_document.cdnPolicy.json
}

resource "aws_s3_bucket_public_access_block" "publicaccess" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = var.blockPublicAcl
  ignore_public_acls      = var.ignorePublicAcls
  block_public_policy     = var.blockPublicPolicy
  restrict_public_buckets = var.restrictPublicBuckets
  depends_on = [
    aws_s3_bucket_policy.policy
  ]
}
