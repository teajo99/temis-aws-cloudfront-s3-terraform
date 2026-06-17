resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {

  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {

  bucket = aws_s3_bucket.website.id

  key = "index.html"

  source = "./website/index.html"

  content_type = "text/html"

  etag = filemd5("./website/index.html")
}


resource "aws_s3_object" "styles" {

  bucket = aws_s3_bucket.website.id

  key = "styles.css"

  source = "./website/styles.css"

  content_type = "text/css"

  etag = filemd5("./website/styles.css")
}

resource "aws_cloudfront_origin_access_control" "oac" {

  name        = "temis-oac"
  description = "OAC for Temis Website"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "website" {

  enabled             = true
  default_root_object = "index.html"

  origin {

    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "s3-origin"

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {

    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    compress = true

    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {

    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [
    aws_s3_bucket.website
  ]
}

data "aws_iam_policy_document" "bucket_policy" {

  statement {

    sid = "AllowCloudFront"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*"
    ]

    principals {

      type = "Service"

      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    condition {

      test = "StringEquals"

      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.website.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {

  bucket = aws_s3_bucket.website.id

  policy = data.aws_iam_policy_document.bucket_policy.json
}