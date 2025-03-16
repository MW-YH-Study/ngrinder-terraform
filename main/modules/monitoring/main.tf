# Prometheus Task Definition
resource "aws_ecs_task_definition" "prometheus" {
  family             = "${var.project_name}-prometheus"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  volume {
    name = "prometheus-data"
    efs_volume_configuration {
      file_system_id = var.prometheus_efs_id
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = var.prometheus_image
      essential = true
      portMappings = [
        {
          containerPort = 9090
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "prometheus-data"
          containerPath = "/prometheus"
          readOnly      = false
        }
      ]
      environment = [
        {
          name  = "PROMETHEUS_CONFIG_FILE"
          value = "/prometheus/prometheus.yml"
        }
      ]
    }
  ])
}

# Prometheus Service
resource "aws_ecs_service" "prometheus" {
  name             = "${var.project_name}-prometheus"
  cluster          = var.ecs_cluster_id
  task_definition  = aws_ecs_task_definition.prometheus.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups = [var.prometheus_security_group_id]
    assign_public_ip = false
  }
}

# Grafana Task Definition
resource "aws_ecs_task_definition" "grafana" {
  family             = "${var.project_name}-grafana"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn

  volume {
    name = "grafana-data"
    efs_volume_configuration {
      file_system_id = var.grafana_efs_id
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = var.grafana_image
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "grafana-data"
          containerPath = "/var/lib/grafana"
          readOnly      = false
        }
      ]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_USER"
          value = "admin"
        },
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = "admin"  # 실제 환경에서는 안전한 암호 사용 필요
        },
        {
          name  = "GF_INSTALL_PLUGINS"
          value = "grafana-clock-panel,grafana-simple-json-datasource"
        }
      ]
    }
  ])
}

# Grafana Service
resource "aws_ecs_service" "grafana" {
  name             = "${var.project_name}-grafana"
  cluster          = var.ecs_cluster_id
  task_definition  = aws_ecs_task_definition.grafana.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups = [var.grafana_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.grafana_alb_target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }
}