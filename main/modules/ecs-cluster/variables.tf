variable "project_name" {
  description = "Project name to be used as prefix for all resources"
  type        = string
  default     = "test-stress"
}

variable "capacity_providers" {
  description = "List of capacity providers to use for the cluster"
  type = list(string)
  default = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy for the cluster"
  type = list(object({
    capacity_provider = string
    weight            = number
    base = optional(number)
  }))
  default = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
      base              = 1
    }
  ]
}
