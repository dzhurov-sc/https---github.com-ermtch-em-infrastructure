
#######################################
# Service declaration for AWS Fargate #
#######################################

# resource "aws_ecs_service" "stateful" {

# #  for_each = { 
# #    for service, definition in var.services_definition : service => definition 
# #    if definition.stateful
# #  }

#   for_each = var.stateful_services

#     name            = each.key

#     cluster         = aws_ecs_cluster.main.id
#     launch_type     = "FARGATE"
#     desired_count   = 1

#     network_configuration {

#       assign_public_ip = true
#       subnets          = var.ecs_subnets
#       security_groups  = [ var.global_sg_id ]

#     }

#     load_balancer {
#       target_group_arn = aws_lb_target_group.stateful_alb_tg[each.key].arn
#       container_name   = each.key
#       container_port   = lookup(each.value, "container_port", "80")
#     }

#     task_definition    = aws_ecs_task_definition.stateful[each.key].arn

# }

# resource "aws_ecs_task_definition" "stateful" {

#   for_each = { for service, definition in var.stateful_services : service => definition }

#     depends_on               = [ aws_efs_access_point.stateful_service_ap ]

#     family                   = each.key
#     task_role_arn            = "arn:aws:iam::160148505254:role/ecs-efs-mount"
#     execution_role_arn       = "arn:aws:iam::160148505254:role/ecs-efs-mount"

#     requires_compatibilities = [ "FARGATE" ]
#     network_mode             = "awsvpc"

#     cpu                      = lookup(each.value, "cpu", "1024")
#     memory                   = lookup(each.value, "memory", "2048")

#     container_definitions    = templatefile("modules/ecs/task-definitions/stateful.tpl",
#       {
#         container_name  = each.key
#         container_image = var.repositories[each.key]
#         container_port  = lookup(each.value, "container_port", "80")
#         host_port       = lookup(each.value, "host_port", "80")
#         project_name    = var.project_name
#         env             = var.env

#         volumes         = lookup(each.value, "volumes", "Should not be empty!")
#       }
#     )

#     dynamic "volume" {

#       # for_each = each.value.volumes
#       for_each = local.volume_mappings

#       content {
#         name                   = volume.value.name
#         efs_volume_configuration {
#           file_system_id       = var.efs_id
#           root_directory       = "/"
#           transit_encryption   = "ENABLED"

#           authorization_config {
#             access_point_id    = aws_efs_access_point.stateful_service_ap[volume.key].id
#             iam                = "ENABLED"
#           }
#         }
#       }
#     }

#     lifecycle {
#       ignore_changes = [ container_definitions ]
#     }

# }

# resource "aws_efs_access_point" "stateful_service_ap" {

#   for_each = local.volume_mappings

#   file_system_id = var.efs_id

#   root_directory  {

#     path = lookup(each.value.config, "host_path", "/tmp")

#     creation_info {
#       owner_uid   = 0
#       owner_gid   = 0
#       permissions = 755
#     }
#   }
# }

# resource "aws_lb_listener_rule" "stateful_service_rule" {

#   for_each = var.stateful_services

#   listener_arn = aws_lb_listener.ecs_alb_listener.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.stateful_alb_tg[each.key].arn
#   }

#   condition {
#     host_header {
#       values = lookup(each.value, "dns_names", [ "*.whimsygames.co" ])
#     }
#   }
# }

# # Health check need to be added
# resource "aws_lb_target_group" "stateful_alb_tg" {

#   for_each = var.stateful_services

#   name        = "${var.cluster_name}-${each.key}"
#   target_type = "ip"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id

#   health_check {
#     enabled   = true
#     interval  = "30"
#     path      = lookup(each.value, "healthcheck_http_path", "/")
#     matcher   = lookup(each.value, "healthcheck_http_codes", "200-404")
#   }
# }


