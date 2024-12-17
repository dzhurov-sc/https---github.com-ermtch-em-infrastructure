module "cloudwatch" {
  source            = "../modules/cloudwatch"
  env               = var.env
  project_name      = var.project_name
  retention_in_days = 14
  stateless_services  = var.stateless_services
  providers = {
    aws.dev_virginia = aws.dev_virginia
  }  
}