resource "aws_cloudfront_origin_access_identity" "accessid" {
  comment = "Origin Access Identify for CF"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = var.ipv6Enabled
  comment             = var.comment
  default_root_object = "index.html"
  # aliases             = ["content-staging.tignum.com"]
  tags = {
    Terraformed = true
    Name        = var.Name
  }

  #   origin {
  #     domain_name = aws_s3_bucket.tcontent-staging.bucket_regional_domain_name
  #     origin_id   = "tc1"

  #     s3_origin_config {
  #       origin_access_identity = aws_cloudfront_origin_access_identity.origaccid.cloudfront_access_identity_path
  #     }
  #   }
  #   origin {
  #     domain_name = aws_s3_bucket.tcontentStagingEu.bucket_regional_domain_name
  #     origin_id   = "tc2"

  #     s3_origin_config {
  #       origin_access_identity = aws_cloudfront_origin_access_identity.origaccid.cloudfront_access_identity_path
  #     }
  #   }
  #   origin_group {
  #     origin_id = "stgGroup1"

  #     failover_criteria {
  #       status_codes = [403, 404, 500, 502]
  #     }

  #     member {
  #       origin_id = "tc2"
  #     }

  #     member {
  #       origin_id = "tc1"
  #     }
  #   }

  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "stgGroup1"
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    trusted_signers        = ["self"]
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
