
##########################
# AWS Provider Variables #
##########################

variable "aws_access_key_em" {
  description = "The AWS access key."
  default     = ""
}

variable "aws_secret_key_em" {
  description = "The AWS secret key."
  default     = ""
}

variable "region" {
  description = "The AWS region to create resources in."
  default     = "eu-north-1"
}

#####################
# Project variables #
#####################

variable "project_name" {
  description = "Project name"
  default     = "euromatch"
}

variable "env" {
  description = "Environment type"
  default     = "stage"
}