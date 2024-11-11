
#######################################
# Service declaration for AWS Fargate #
#######################################

# resource "aws_ecs_service" "nginx" {
#   name            = "IaC-nginx"

#   cluster         = aws_ecs_cluster.main.id
#   launch_type     = "FARGATE"
#   desired_count   = 1

#   network_configuration {

#     assign_public_ip = true
#     subnets          = var.ecs_subnets
#     security_groups  = [ var.global_sg_id ]

#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
#     container_name   = "nginx-test"
#     container_port   = 80
#   }

#   task_definition    = aws_ecs_task_definition.nginx.arn

# }

# resource "aws_ecs_task_definition" "nginx" {
#   family                   = "nginx-test"

#   requires_compatibilities = [ "FARGATE" ]
#   network_mode             = "awsvpc"

#   cpu                      = 1024
#   memory                   = 2048
#   container_definitions    = file("modules/ecs/task-definitions/nginx-test.json")
# }

