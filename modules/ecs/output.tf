
###################################
# Output Variables for ECS module #
###################################

output "output_cluster_name" {
  value = aws_ecs_cluster.main.id
}

output "alb_dns_name" {
  value = aws_lb.ecs_alb.dns_name
}

output "repository_addresses" {
  value = {
    for repo in aws_ecr_repository.repository :
    repo.name => repo.repository_url
  }
}

output "test" {
  value = "test output"
}