output "prometheus_service_id" {
  description = "ID of the Prometheus ECS service"
  value       = aws_ecs_service.prometheus.id
}

output "grafana_service_id" {
  description = "ID of the Grafana ECS service"
  value       = aws_ecs_service.grafana.id
}

output "prometheus_task_definition_arn" {
  description = "ARN of the Prometheus task definition"
  value       = aws_ecs_task_definition.prometheus.arn
}

output "grafana_task_definition_arn" {
  description = "ARN of the Grafana task definition"
  value       = aws_ecs_task_definition.grafana.arn
}
