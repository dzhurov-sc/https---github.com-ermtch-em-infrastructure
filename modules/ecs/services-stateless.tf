#######################################
# Service declaration for AWS Fargate V2 #
#######################################


resource "aws_ecs_task_definition" "stateless" {

  for_each = var.stateless_services

  family = each.key

  execution_role_arn = each.value.execution_role
  
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = lookup(each.value, "cpu", "1024")
  memory = lookup(each.value, "memory", "2048")

  container_definitions = templatefile("../modules/ecs/task-definitions/stateless_${var.env}.tpl",
    {
      container_name  = each.key
     # container_image = "${local.repositories[each.key]}"
      container_image = "nginx:latest"
      container_port  = lookup(each.value, "container_port", "80")
      host_port       = lookup(each.value, "host_port", "80")
      project_name    = var.project_name
      env             = var.env
      region          = var.region
    }
  )

  # lifecycle {
  #   ignore_changes = [container_definitions]
  # }

}

resource "aws_ecs_service" "stateless" {

  for_each = var.stateless_services

  name            = each.key
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = lookup(each.value, "desired_count", "1")
  task_definition = aws_ecs_task_definition.stateless[each.key].arn
  # use exec for container debugging(edit task role with that) false by default
  # enable_execute_command = each.key == "undeads-site" ? true : false

  network_configuration {
    assign_public_ip = false
    subnets          = var.ecs_subnets
    security_groups  = [var.ecs_sg_id]
  }

  load_balancer {
      target_group_arn = aws_lb_target_group.stateless_alb_tg[each.key].arn
      container_name   = each.key
      container_port   = lookup(each.value, "container_port", "80")
  }
  # lifecycle {
  #   ignore_changes = [ task_definition ]
  # }
}

resource "aws_lb_target_group" "stateless_alb_tg" {

  for_each = var.stateless_services

  name        = "${local.cluster_name}-${each.key}"
  target_type = "ip"
  port        = each.value["host_port"]
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    interval = "30"
    path     = lookup(each.value, "healthcheck_http_path", "/")
    matcher  = lookup(each.value, "healthcheck_http_codes", "200-404")
  }
  # Implement create_b_d to comply auto-updates without manual changes! (rnd for tgs!)
  lifecycle {
    create_before_destroy = true
  }  
}

resource "aws_lb_listener_rule" "stateless_service_rule" {

  for_each = var.stateless_services

  listener_arn = aws_lb_listener.ecs_alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stateless_alb_tg[each.key].arn
  }

  condition {
    host_header {
      values = [lookup(each.value, "dns_names", ["*.ogs.com"])]
    }
  }
}

# Health check need to be added


