# Network Module
module "network" {
  source = "./modules/network"

  project_name = var.project_name
  azs          = var.azs
}

# Security Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  vpc_cidr     = module.network.vpc_cidr
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  private_subnet_id     = module.network.private_subnet_id
  db_private_subnet_ids = module.network.private_db_subnet_ids
  rds_password          = var.rds_password
  rds_security_group_id = module.security.rds_security_group_id
}

# # ECS Cluster Module
# module "ecs" {
#   source = "./modules/ecs-cluster"
#
#   project_name = var.project_name
# }

# # Load Balancers
# module "chat_alb" {
#   source = "./modules/alb"
#
#   project_name      = var.project_name
#   vpc_id            = module.network.vpc_id
#   subnet_ids        = module.network.public_subnet_ids
#   security_group_id = module.security.external_alb_security_group_id
#   internal          = false
#   alb_name          = "chat"
#   target_port       = 9090
#   health_check_path = "/actuator/health"
# }
#
# module "push_alb" {
#   source = "./modules/alb"
#
#   project_name      = var.project_name
#   vpc_id            = module.network.vpc_id
#   subnet_ids        = module.network.private_subnet_ids
#   security_group_id = module.security.internal_alb_security_group_id
#   internal          = true
#   alb_name          = "push"
#   target_port       = 8090
#   health_check_path = "/actuator/health"
# }
#
# module "monitoring_alb" {
#   source = "./modules/alb"
#
#   project_name      = var.project_name
#   vpc_id            = module.network.vpc_id
#   subnet_ids        = module.network.private_subnet_ids
#   security_group_id = module.security.internal_alb_security_group_id
#   internal          = true
#   alb_name          = "monitoring"
#   target_port       = 3000
#   health_check_path = "/api/health"
# }
#
# # Application Servers
# module "chat_server" {
#   source = "./modules/ecs-app"
#
#   project_name        = var.project_name
#   app_name            = "chat"
#   vpc_id              = module.network.vpc_id
#   subnet_ids          = module.network.private_subnet_ids
#   security_group_id   = module.security.chat_security_group_id
#   ecs_cluster_id      = module.ecs.cluster_id
#   ecs_cluster_name    = module.ecs.cluster_name
#   container_image     = "yeonhyukkim/fake-chat-server:latest"
#   container_port      = 9090
#   target_group_arn    = module.chat_alb.target_group_arn
#   task_role_arn       = module.security.ecs_task_role_arn
#   execution_role_arn  = module.security.ecs_task_execution_role_arn
#   enable_auto_scaling = false
#
#   environment_variables = [
#     {
#       name  = "SPRING_DATASOURCE_JDBC_URL"
#       value = "jdbc:postgresql://${module.storage.rds_address}:${module.storage.rds_port}/${module.storage.rds_database_name}"
#     },
#     {
#       name  = "PUSH_SERVER_URL"
#       value = "http://${module.push_alb.alb_dns_name}:8090"
#     }
#   ]
# }
#
# module "push_server" {
#   source = "./modules/ecs-app"
#
#   project_name        = var.project_name
#   app_name            = "push"
#   vpc_id              = module.network.vpc_id
#   subnet_ids          = module.network.private_subnet_ids
#   security_group_id   = module.security.push_security_group_id
#   ecs_cluster_id      = module.ecs.cluster_id
#   ecs_cluster_name    = module.ecs.cluster_name
#   container_image     = "yeonhyukkim/fake-push-server:latest"
#   container_port      = 8090
#   target_group_arn    = module.push_alb.target_group_arn
#   task_role_arn       = module.security.ecs_task_role_arn
#   execution_role_arn  = module.security.ecs_task_execution_role_arn
#   enable_auto_scaling = false
#   desired_count       = var.push_server_count
#   min_capacity        = 1
#   max_capacity        = 4
# }
#
# # Monitoring
# module "monitoring" {
#   source = "./modules/monitoring"
#
#   project_name                 = var.project_name
#   vpc_id                       = module.network.vpc_id
#   subnet_ids                   = module.network.private_subnet_ids
#   prometheus_security_group_id = module.security.prometheus_security_group_id
#   grafana_security_group_id    = module.security.grafana_security_group_id
#   ecs_cluster_id               = module.ecs.cluster_id
#   prometheus_efs_id            = module.storage.prometheus_efs_id
#   grafana_efs_id               = module.storage.grafana_efs_id
#   grafana_alb_target_group_arn = module.monitoring_alb.target_group_arn
#   task_execution_role_arn      = module.security.ecs_task_execution_role_arn
#   task_role_arn                = module.security.ecs_task_role_arn
# }

# ngrinder
module "ngrinder" {
  source = "./modules/ngrinder"

  project_name            = var.project_name
  task_execution_role_arn = module.security.ecs_task_execution_role_arn
  task_role_arn           = module.security.ecs_task_role_arn
  agent_count             = var.ngrinder_agent_count
  azs                     = var.azs
  efs_id                  = var.ngrinder_efs_id
}
