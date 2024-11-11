
################################
# Variables for AWS ECS module #
################################

variable "project_name" {
  default = "euromatch"
}

variable "env" {
}

variable "region" {
}

variable "vpc_id" {
}

variable "lb_subnets" {
}

variable "ecs_subnets" {
}

variable "acm_certificate_arn" {
}
variable "ecs_sg_id" {
}

variable "alb_sg_id" {  
}
variable "stateless_services" {
}

variable "force_delete" {
  default = false
}
