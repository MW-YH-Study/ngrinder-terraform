output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "external_alb_security_group_id" {
  description = "ID of the external ALB security group"
  value       = aws_security_group.external_alb.id
}

output "internal_alb_security_group_id" {
  description = "ID of the internal ALB security group"
  value       = aws_security_group.internal_alb.id
}

output "chat_security_group_id" {
  description = "ID of the Chat Server security group"
  value       = aws_security_group.chat.id
}

output "push_security_group_id" {
  description = "ID of the Push Server security group"
  value       = aws_security_group.push.id
}

output "prometheus_security_group_id" {
  description = "ID of the Prometheus security group"
  value       = aws_security_group.prometheus.id
}

output "grafana_security_group_id" {
  description = "ID of the Grafana security group"
  value       = aws_security_group.grafana.id
}
