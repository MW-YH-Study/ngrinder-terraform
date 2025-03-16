variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnet"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.16.0/24"]
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "controller_image" {
  description = "Docker image for ngrinder controller"
  type        = string
  default     = "ngrinder/controller"
}

variable "agent_image" {
  description = "Docker image for ngrinder agent"
  type        = string
  default     = "ngrinder/agent"
}

variable "agent_count" {
  description = "Number of ngrinder agents to run"
  type        = number
  default     = 3
}

variable "azs" {
  description = "Availability zones"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "efs_id" {
  description = "EFS ID"
  type        = string
}
