variable "stateless_services" {
  description = "Stateless Services description"
  type        = map(any)
  default = {

    "api" = {
      execution_role         = "arn:aws:iam::509399618451:role/ecs-task-execution"
      dns_names              = "testv1.groovesharks.world"
      desired_count          = 0
      cpu                    = 1024
      memory                 = 2048
      container_port         = "80"
      host_port              = "80"
      healthcheck_http_path  = "/health"
      healthcheck_http_codes = "200-404"
    }
  }
}