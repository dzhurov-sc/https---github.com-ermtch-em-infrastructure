
########################
# Dynamic locals block #
########################

locals {
  cluster_name = "${var.env}-${var.project_name}-ecs"

  services_definition = var.stateless_services

  repositories = {
    for repo in aws_ecr_repository.repository :
    repo.id => repo.repository_url
  }
}