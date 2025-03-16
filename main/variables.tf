variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "stress"
}

variable "ngrinder_efs_id" {
  description = "EFS ID for ngrinder"
  type        = string
  default     = "fs-0d5cfc38cb6a62ca2"
}

variable "prometheus_efs_id" {
  description = "EFS ID for prometheus"
  type        = string
  default     = "fs-03dceda1a9a35c4b6"
}

variable "grafana_efs_id" {
  description = "EFS ID for grafana"
  type        = string
  default     = "fs-0f741a737772c60c5"
}

variable "rds_password" {
  description = "Password for RDS instance"
  type        = string
  sensitive   = true
  default     = "password"
}

variable "ngrinder_agent_count" {
  description = "Number of ngrinder agents to run"
  type        = number
  default     = 3
}

variable "push_server_count" {
  description = "Number of push servers to run"
  type        = number
  default     = 1
}

variable "azs" {
  description = "Availability zones"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}