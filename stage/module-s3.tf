module "s3" {
  source                = "../modules/s3"
  project_name       = var.project_name
  env                   = var.env
  bucket_key_enabled    = false
  force_destroy         = true
  http_secret_header    = var.http_stage_secret_header_em
  providers = {
    aws.dev_virginia = aws.dev_virginia
  }
}

output "s3_cloudfront_website_name" {
  value = module.s3.s3_bucket_webstatic_name
}

output "s3_cloudfront_assets_name" {
  value = module.s3.s3_bucket_assets_name
}
