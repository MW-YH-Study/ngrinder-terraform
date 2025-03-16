variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "app_name" {
  description = "Name of the application (chat/push)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the service will be deployed"
  type = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ECS tasks"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
}

variable "container_port" {
  description = "Port number the container exposes"
  type        = number
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "enable_auto_scaling" {
  description = "Whether to enable auto scaling"
  type        = bool
  default     = false
}

variable "max_capacity" {
  description = "Maximum number of tasks when auto scaling is enabled"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Minimum number of tasks when auto scaling is enabled"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
