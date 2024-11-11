terraform {
  backend "s3" {
    bucket  = "stage-euromatch-tfstate"
    key     = "stage.tfstate"
    profile = "euromatch"
    region  = "eu-central-1"
  }
}
