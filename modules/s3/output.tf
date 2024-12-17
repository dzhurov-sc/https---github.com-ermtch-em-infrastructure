
###################################
# Output Variables for S3 module #
###################################

output "s3_bucket_webstatic_name" {
  value = aws_s3_bucket.em_website.bucket_regional_domain_name
}

output "s3_bucket_assets_name" {
  value = aws_s3_bucket.em_assets.bucket_regional_domain_name
}