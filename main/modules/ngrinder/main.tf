module "ecs_cluster" {
  source       = "../ecs-cluster"
  project_name = "${var.project_name}-ngrinder"
}

# Service Connect를 위한 HTTP 네임스페이스 생성
resource "aws_service_discovery_http_namespace" "ngrinder" {
  name        = "${var.project_name}-namespace"
  description = "Namespace for ngrinder controller and agent communication"

  tags = {
    Name = "${var.project_name}-ngrinder-namespace"
  }
}


# ngrinder Controller Task Definition
resource "aws_ecs_task_definition" "controller" {
  family             = "${var.project_name}-controller"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "1024"
  memory             = "2048"
  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  tags = {
    Name = "${var.project_name}-ngrinder-controller"
  }

  volume {
    name = "ngrinder-controller-volume"
    efs_volume_configuration {
      file_system_id = data.aws_efs_file_system.controller_efs.id
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name         = "ngrinder-controller"
      image        = var.controller_image
      essential    = true
      startTimeout = 120
      stopTimeout  = 120
      portMappings = [
        {
          name          = "ngrinder-controller-http"
          containerPort = 80
          protocol      = "tcp"
        },
        {
          name          = "ngrinder-controller-control"
          containerPort = 16001
          protocol      = "tcp"
        },
        {
          name          = "ngrinder-controller-agent"
          containerPort = 12000
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "ngrinder-controller-volume"
          containerPath = "/opt/ngrinder-controller"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ngrinder.name
          "awslogs-region"        = "ap-northeast-2"
          "awslogs-stream-prefix" = aws_cloudwatch_log_stream.ngrinder_controller.name
        }
      }
    }
  ])
}

# ngrinder Agent Task Definition
resource "aws_ecs_task_definition" "agent" {
  family             = "${var.project_name}-agent"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "2048"
  memory             = "4096"
  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  tags = {
    Name = "${var.project_name}-ngrinder-agent"
  }

  container_definitions = jsonencode([
    {
      name         = "ngrinder-agent"
      image        = var.agent_image
      essential    = true
      startTimeout = 120
      stopTimeout  = 120
      entryPoint = [
        "/scripts/run.sh",
        "${var.project_name}-ngrinder"
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ngrinder.name
          "awslogs-region"        = "ap-northeast-2"
          "awslogs-stream-prefix" = aws_cloudwatch_log_stream.ngrinder_agent.name
        }
      }
    }
  ])
}

# Controller Service
resource "aws_ecs_service" "controller" {
  name             = "${var.project_name}-controller"
  cluster          = module.ecs_cluster.cluster_id
  task_definition  = aws_ecs_task_definition.controller.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = aws_subnet.ngrinder_public[*].id
    security_groups = [aws_security_group.controller.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.controller.arn
    container_name   = "ngrinder-controller"
    container_port   = 80
  }

  tags = {
    Name = "${var.project_name}-ngrinder-controller"
  }

  # Service Connect 설정
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.ngrinder.arn
    log_configuration {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ngrinder.name
        "awslogs-region"        = "ap-northeast-2"
        "awslogs-stream-prefix" = aws_cloudwatch_log_stream.ngrinder_service_connect.name
      }
    }

    service {
      client_alias {
        port     = 80
        dns_name = "${var.project_name}-ngrinder"
      }
      port_name      = "ngrinder-controller-http"
      discovery_name = "${var.project_name}-ngrinder-http"
    }

    service {
      client_alias {
        port     = 16001
        dns_name = "${var.project_name}-ngrinder"
      }
      port_name      = "ngrinder-controller-control"
      discovery_name = "${var.project_name}-ngrinder-control"
    }

    service {
      client_alias {
        port     = 12000
        dns_name = "${var.project_name}-ngrinder"
      }
      port_name      = "ngrinder-controller-agent"
      discovery_name = "${var.project_name}-ngrinder-agent"
    }
  }
}

# Agent Service
resource "aws_ecs_service" "agent" {
  name             = "${var.project_name}-agent"
  cluster          = module.ecs_cluster.cluster_id
  task_definition  = aws_ecs_task_definition.agent.arn
  desired_count    = var.agent_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  depends_on = [aws_ecs_service.controller]

  tags = {
    Name = "${var.project_name}-ngrinder-agent"
  }

  network_configuration {
    subnets          = aws_subnet.ngrinder_public[*].id
    security_groups = [aws_security_group.agent.id]
    assign_public_ip = false
  }

  # Service Connect 설정
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.ngrinder.arn
    log_configuration {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ngrinder.name
        "awslogs-region"        = "ap-northeast-2"
        "awslogs-stream-prefix" = aws_cloudwatch_log_stream.ngrinder_service_connect.name
      }
    }
  }
}
