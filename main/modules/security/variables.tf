variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "test-stress"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}
