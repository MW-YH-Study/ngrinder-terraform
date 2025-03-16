variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "test-stress"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnet"
  type = list(string)
  default = ["10.1.1.0/24", "10.1.8.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = string
  default     = "10.1.16.0/24"
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private db subnets"
  type = list(string)
  default = ["10.1.24.0/24", "10.1.32.0/24"]
}

variable "azs" {
  description = "Availability zones"
  type = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}
