
##############################
# AWS ECS module declaration #
##############################

module "ecs" {
  source = "../modules/ecs"

  project_name = var.project_name
  env          = var.env
  region       = var.region

  vpc_id              = module.vpc.vpc_id
  lb_subnets          = module.vpc.public_subnets
  ecs_subnets         = module.vpc.private_subnets
  alb_sg_id           = module.vpc.alb_sg_id
  ecs_sg_id           = module.vpc.ecs_sg_id
  acm_certificate_arn = "arn:aws:acm:eu-north-1:509399618451:certificate/fb60a917-af05-474d-9005-67ed64b93729"
  stateless_services  = var.stateless_services
}

output "ecs_cluster_name" { value = module.ecs.output_cluster_name }
output "repository_addresses" { value = module.ecs.repository_addresses }