resource "aws_lb" "controller" {
  name                       = "${var.project_name}-controller"
  internal                   = false
  load_balancer_type         = "application"
  security_groups = [aws_security_group.controller_lb.id]
  enable_deletion_protection = false
  subnets                    = aws_subnet.ngrinder_public[*].id

  tags = {
    Name = "${var.project_name}-ngrinder-controller"
  }
}

resource "aws_lb_target_group" "controller" {
  name        = "${var.project_name}-controller-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ngrinder.id
  target_type = "ip"

  deregistration_delay = 1

  health_check {
    enabled  = true
    interval = 80
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    timeout  = 70
    matcher  = "200-399"
  }

  tags = {
    Name = "${var.project_name}-ngrinder-controller-tg"
  }

}

resource "aws_lb_listener" "ngrinder_controller" {
  load_balancer_arn = aws_lb.controller.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controller.arn
  }

  tags = {
    Name = "${var.project_name}-ngrinder-controller-listener"
  }
}
