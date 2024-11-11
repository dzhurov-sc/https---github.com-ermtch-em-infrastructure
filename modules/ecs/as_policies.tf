# resource "aws_appautoscaling_policy" "cpu" {
#   for_each           = var.stateless_services
#   name               = "${var.env}-ECS-CPU"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#   target_tracking_scaling_policy_configuration {
#     target_value       = 80
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 80

#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#   }
# }

# resource "aws_appautoscaling_policy" "ram" {
#   for_each           = var.stateless_services
#   name               = "${var.env}-ECS-RAM"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_target[each.key].resource_id
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
#   target_tracking_scaling_policy_configuration {
#     target_value       = 80
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 300

#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }
#   }
# }

# resource "aws_appautoscaling_target" "ecs_target" {
#   # Filter the resources by the names
#   for_each           = var.stateless_services
#   min_capacity       = 2
#   max_capacity       = 4
#   resource_id        = "service/${aws_ecs_cluster.main.name}/${each.key}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

