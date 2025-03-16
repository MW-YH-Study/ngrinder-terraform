# modules/alb/variables.tf
variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "test-stress"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "internal" {
  description = "Boolean flag to determine if ALB is internal"
  type        = bool
  default     = false
}

variable "target_type" {
  description = "Type of target for the target group (instance, ip, lambda, alb)"
  type        = string
  default     = "ip"
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "target_port" {
  description = "Port on which targets receive traffic"
  type        = number
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/health"
}

variable "health_check_port" {
  description = "Port for health check"
  type        = string
  default     = "traffic-port"
}

variable "deregistration_delay" {
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused"
  type        = number
  default     = 30
}
