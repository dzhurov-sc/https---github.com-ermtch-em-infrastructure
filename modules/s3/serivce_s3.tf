resource "aws_s3_bucket" "em_alb_logs" {
  bucket        = local.s3_logs_alb_name
  force_destroy = var.force_destroy
}