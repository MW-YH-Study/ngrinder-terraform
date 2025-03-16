variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the services will be deployed"
  type = list(string)
}

variable "prometheus_security_group_id" {
  description = "Security group ID for Prometheus"
  type        = string
}

variable "grafana_security_group_id" {
  description = "Security group ID for Grafana"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "prometheus_efs_id" {
  description = "ID of the EFS filesystem for Prometheus"
  type        = string
}

variable "grafana_efs_id" {
  description = "ID of the EFS filesystem for Grafana"
  type        = string
}

variable "grafana_alb_target_group_arn" {
  description = "ARN of the ALB target group for Grafana"
  type        = string
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "prometheus_image" {
  description = "Docker image for Prometheus"
  type        = string
  default     = "prom/prometheus:latest"
}

variable "grafana_image" {
  description = "Docker image for Grafana"
  type        = string
  default     = "grafana/grafana:latest"
}
