resource "aws_cloudwatch_log_group" "alb_waf" {
  name              = "aws-waf-logs-${var.env}-alb"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "cf_waf" {
  provider      = aws.dev_virginia
  name              = "aws-waf-logs-${var.env}-cf"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_log_group" "cf_website" {
  provider      = aws.dev_virginia  
  name              = "/cf-website/${var.env}/${var.project_name}"
  retention_in_days = var.retention_in_days
}
