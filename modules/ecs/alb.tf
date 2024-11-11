# Health check need to be added
resource "aws_lb_target_group" "ecs_alb_tg" {
  name        = "${local.cluster_name}-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "ecs_alb" {
  name               = "${local.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.lb_subnets

  enable_deletion_protection = false

  # Load Balancer logging need to be added
  # access_logs {
  #   bucket = "prod-alb-logs-und"
  #   #  prefix  = "since2106"
  #   enabled = var.env == "prod" ? true : false
  # }

}

resource "aws_lb_listener" "ecs_alb_default_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}
