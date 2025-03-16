# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.alb_name}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.alb_name}"
  }
}

# Target Group
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-${var.alb_name}-tg"
  port        = var.target_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    interval            = 30
    path                = var.health_check_path
    port                = var.health_check_port
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    matcher             = "200-299"
  }

  deregistration_delay = var.deregistration_delay

  tags = {
    Name = "${var.project_name}-${var.alb_name}-tg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
