output "vpc_id" {
  value = aws_vpc.ngrinder.id
}

output "vpc_cidr" {
  value = aws_vpc.ngrinder.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.ngrinder_public[*].id
}

output "controller_service_id" {
  description = "ID of the ngrinder controller ECS service"
  value       = aws_ecs_service.controller.id
}

output "agent_service_id" {
  description = "ID of the ngrinder agent ECS service"
  value       = aws_ecs_service.agent.id
}

output "controller_task_definition_arn" {
  description = "ARN of the controller task definition"
  value       = aws_ecs_task_definition.controller.arn
}

output "agent_task_definition_arn" {
  description = "ARN of the agent task definition"
  value       = aws_ecs_task_definition.agent.arn
}

output "controller_lb_dns_name" {
  description = "DNS name of the ngrinder controller load balancer"
  value       = aws_lb.controller.dns_name
}