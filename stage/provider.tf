
##########################
# Terraform AWS Provider #
##########################

provider "aws" {
  access_key = var.aws_access_key_em
  secret_key = var.aws_secret_key_em
  region     = var.region

  default_tags {
    tags = {
      Environment = var.env
      Project     = var.project_name
    }
  }
}