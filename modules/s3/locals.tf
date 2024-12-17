locals {
  s3_cloudfront_website_name = "${var.env}-${var.project_name}-website"
  s3_cloudfront_assets_name  = "${var.env}-${var.project_name}-assets"
  s3_logs_alb_name           = "${var.env}-${var.project_name}-alb-logs"
}