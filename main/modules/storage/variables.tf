variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "test-stress"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "db_private_subnet_ids" {
  description = "DB Private subnet IDs"
  type = list(string)
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_database_name" {
  description = "Name of the database"
  type        = string
  default     = "chat_server"
}

variable "rds_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "postgres"
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "rds_security_group_id" {
  description = "Security group ID for RDS instance"
  type        = string
}