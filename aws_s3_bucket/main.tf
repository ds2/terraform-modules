resource "aws_s3_bucket" "bucket" {
  bucket        = var.name
  force_destroy = true

  tags = {
    Name         = var.name
    Terraformed  = true
    s3BucketName = var.name
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioned ? "Enabled" : "Disabled"
  }
}



resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  count  = var.encryptContent ? 1 : 0
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kmsKeyArn != null ? var.kmsKeyArn : null
      sse_algorithm     = var.kmsKeyArn != null ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycles" {
  bucket = aws_s3_bucket.bucket.bucket
  rule {
    id = "agingOutdatedVersions"

    filter {
      prefix = var.versionObjPrefix
    }
    status = var.versioned ? "Enabled" : "Disabled"

    noncurrent_version_transition {
      noncurrent_days = var.oneZoneDays
      storage_class   = "ONEZONE_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = var.glacierDays
      storage_class   = "GLACIER"
    }
    noncurrent_version_transition {
      noncurrent_days = var.deepArchiveDays
      storage_class   = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.ncvExpirationDays
    }
    expiration {
      days                         = var.delCurrObjAfterDays
      expired_object_delete_marker = true
    }
  }
  rule {
    id     = "removeIncompleteUploads"
    status = var.maxUploadDays > 0 ? "Enabled" : "Disabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = var.maxUploadDays
    }
  }

  rule {
    id     = "deleteAfterDays"
    status = var.delCurrObjAfterDays > 0 && !var.versioned ? "Enabled" : "Disabled"
    filter {
      prefix = var.delObjPrefix
    }

    expiration {
      days                         = var.delCurrObjAfterDays
      expired_object_delete_marker = true
    }
  }

  rule {
    id = "agingCurrentVersions"

    filter {
      prefix = var.versionObjPrefix
    }
    status = var.enableCurrVersionAging ? "Enabled" : "Disabled"

    transition {
      days          = var.oneZoneDays
      storage_class = "ONEZONE_IA"
    }
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  count  = var.isWebsite ? 1 : 0
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = var.websiteRedirectAllTo != null ? null : var.websiteIndexFile
  }

  error_document {
    key = var.websiteRedirectAllTo != null ? null : var.websiteErrorFile
  }
  redirect_all_requests_to {
    protocol  = "https"
    host_name = var.websiteRedirectAllTo
  }

}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.bucket.bucket

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
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
