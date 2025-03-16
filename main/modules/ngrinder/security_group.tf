# ngrinder Controller Security Group
resource "aws_security_group" "controller" {
  name        = "${var.project_name}-controller-sg"
  description = "Security group for Ngrinder controller"
  vpc_id      = aws_vpc.ngrinder.id

  ingress {
    description = "Web interface access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Controller port"
    from_port   = 16001
    to_port     = 16001
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Agent connection"
    from_port   = 12000
    to_port     = 12000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ngrinder-controller-sg"
  }
}

# ngrinder Agent Security Group
resource "aws_security_group" "agent" {
  name        = "${var.project_name}-agent-sg"
  description = "Security group for Ngrinder agents"
  vpc_id      = aws_vpc.ngrinder.id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ngrinder-agent-sg"
  }
}

# ngrinder controller LB Security Group
resource "aws_security_group" "controller_lb" {
  name        = "${var.project_name}-controller_lb-sg"
  description = "Security group for Ngrinder controller LB"
  vpc_id      = aws_vpc.ngrinder.id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ngrinder-controller-lb-sg"
  }
}
