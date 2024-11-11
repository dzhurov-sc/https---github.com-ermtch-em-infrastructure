
################################
# VPC's Security Groups #
################################

resource "aws_security_group" "alb" {
  name        = "${var.env}-${var.project_name}-alb-sg"
  description = "IaaC managed SG for ALB"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name        = "${var.env}-${var.project_name}-ecs-sg"
  description = "IaaC managed SG for ECS"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    security_groups = [aws_security_group.alb.id]
    description = "Allow Access from ${aws_security_group.alb.name}"
  }
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self = true
    description = "Allow Self-Access"
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}