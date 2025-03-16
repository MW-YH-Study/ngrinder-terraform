# outputs.tf
# output "chat_server_url" {
#   description = "URL for the Chat Server"
#   value       = "http://${module.chat_alb.alb_dns_name}"
# }

# output "grafana_url" {
#   description = "URL for Grafana"
#   value       = "http://${module.monitoring_alb.alb_dns_name}"
# }

# output "rds_endpoint" {
#   description = "Endpoint for RDS instance"
#   value       = module.storage.rds_endpoint
# }

output "ngrinder_controller_lb_dns" {
  value = module.ngrinder.controller_lb_dns_name
}
