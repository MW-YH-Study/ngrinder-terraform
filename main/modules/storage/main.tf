# RDS subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = var.db_private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet"
  }
}

# RDS instance
# resource "aws_db_instance" "postgres" {
#   identifier        = "${var.project_name}-postgres"
#   engine            = "postgres"
#   engine_version    = "14"
#   instance_class    = var.rds_instance_class
#   allocated_storage = 20
#
#   db_name  = var.rds_database_name
#   username = var.rds_username
#   password = var.rds_password
#
#   db_subnet_group_name = aws_db_subnet_group.main.name
#   vpc_security_group_ids = [var.rds_security_group_id]
#
#   skip_final_snapshot = false
#   deletion_protection = true
#   publicly_accessible = true
#
#   tags = {
#     Name = "${var.project_name}-postgres"
#   }
# }