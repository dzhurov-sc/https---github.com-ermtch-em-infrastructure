output "cf_website_lg_arn" {
  value = aws_cloudwatch_log_group.cf_website.arn
}

output "cf_waf_lg_arn" {
  value = aws_cloudwatch_log_group.cf_waf.arn
}

output "cf_alb_lg_arn" {
  value = aws_cloudwatch_log_group.alb_waf.arn
}