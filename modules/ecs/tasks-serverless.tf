# resource "aws_ecr_repository" "tasks_repository" {

#   for_each = var.stateless_tasks

#   name                 = each.key
#   image_tag_mutability = "MUTABLE"

#   force_delete = var.force_delete

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

# resource "aws_ecs_task_definition" "stateless_tasks" {

#   for_each = var.stateless_tasks
#   family   = each.key

#   execution_role_arn = each.value.execution_role
#   task_role_arn      = each.value.task_role

#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"

#   cpu    = lookup(each.value, "cpu", "1024")
#   memory = lookup(each.value, "memory", "2048")

#   container_definitions = templatefile("../modules/ecs/task-definitions/stateless_${var.env}.tpl",
#     {
#       container_name  = each.key
#       container_image = "${local.task_repositories[each.key]}"
#       container_port  = lookup(each.value, "container_port", "80")
#       host_port       = lookup(each.value, "host_port", "80")
#       project_name    = var.project_name
#       env             = var.env
#       region          = var.region
#     }
#   )

#   # lifecycle {
#   #   ignore_changes = [container_definitions]
#   # }

# }