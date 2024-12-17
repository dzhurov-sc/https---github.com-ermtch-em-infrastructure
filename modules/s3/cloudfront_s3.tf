resource "aws_s3_bucket" "em_website" {
  bucket        = local.s3_cloudfront_website_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket" "em_assets" {
  bucket        = local.s3_cloudfront_assets_name
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket" "em_assets_backup" {
  count         = var.env == "prod" ? 1 : 0
  provider      = aws.dev_virginia
  bucket        = "${local.s3_cloudfront_assets_name}-backupv2"
  force_destroy = "true"
}

resource "aws_s3_bucket_versioning" "source" {
  count  = var.env == "prod" ? 1 : 0
  bucket = aws_s3_bucket.em_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "destination" {
  count    = var.env == "prod" ? 1 : 0
  provider = aws.dev_virginia
  bucket   = aws_s3_bucket.em_assets_backup[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_replication_configuration" "replication" {
#   count      = var.env == "prod" ? 1 : 0
#   depends_on = [aws_s3_bucket_versioning.source]

#   bucket = aws_s3_bucket.cf_assets.id
#   role   = "arn:aws:iam::160148505254:role/s3-replication"

#   rule {
#     id = "crr-replication"

#     status = "Enabled"

#     destination {
#       bucket        = aws_s3_bucket.cf_assets_backup[0].arn
#       storage_class = "STANDARD_IA"
#     }
#   }
# }

resource "aws_s3_bucket_public_access_block" "em_website" {
  bucket = aws_s3_bucket.em_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "em_assets" {
  bucket = aws_s3_bucket.em_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "em_website" {
  bucket = aws_s3_bucket.em_website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

data "aws_iam_policy_document" "em_website" {
  statement {
    sid = "Allow Access by Referer"

    actions = [
      "s3:GetObject"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.em_website.arn}/*"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:Referer"

      values = ["${var.http_secret_header}"]
    }
  }
}

resource "aws_s3_bucket_policy" "eb_website_access" {
  bucket = aws_s3_bucket.em_website.id
  policy = data.aws_iam_policy_document.em_website.json
}

# resource "aws_s3_bucket_policy" "cf_webstatic_access" {
#   bucket = aws_s3_bucket.cf_webstatic.id
#   policy = <<EOF
# {
#         "Version": "2008-10-17",
#         "Id": "PolicyForCloudFrontPrivateContent",
#         "Statement": [
#             {
#                 "Sid": "AllowCloudFrontServicePrincipal",
#                 "Effect": "Allow",
#                 "Principal": {
#                     "Service": "cloudfront.amazonaws.com"
#                 },
#                 "Action": "s3:GetObject",
#                 "Resource": "${aws_s3_bucket.cf_webstatic.arn}/*",
#                 "Condition": {
#                     "StringEquals": {
#                       "AWS:SourceArn": "${var.cloudfront_arn}"
#                     }
#                 }
#             }
#         ]
#       }
# EOF
# }

# resource "aws_s3_bucket_policy" "cf_assets_access" {
#   bucket = aws_s3_bucket.cf_assets.id
#   policy = <<EOF
# {
#         "Version": "2008-10-17",
#         "Id": "PolicyForCloudFrontPrivateContent",
#         "Statement": [
#             {
#                 "Sid": "AllowCloudFrontServicePrincipal",
#                 "Effect": "Allow",
#                 "Principal": {
#                     "Service": "cloudfront.amazonaws.com"
#                 },
#                 "Action": "s3:GetObject",
#                 "Resource": "${aws_s3_bucket.cf_assets.arn}/*",
#                 "Condition": {
#                     "StringEquals": {
#                       "AWS:SourceArn": "${var.cloudfront_assets_arn}"
#                     }
#                 }
#             }
#         ]
#       }
# EOF
# }

