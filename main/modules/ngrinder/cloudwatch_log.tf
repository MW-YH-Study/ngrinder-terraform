resource "aws_cloudwatch_log_group" "ngrinder" {
  name              = "${var.project_name}-ngrinder"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "ngrinder_service_connect" {
  name              = "${var.project_name}-service-connect"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ngrinder_controller" {
  name           = "${var.project_name}-controller"
  log_group_name = aws_cloudwatch_log_group.ngrinder.name
}

resource "aws_cloudwatch_log_stream" "ngrinder_agent" {
  name           = "${var.project_name}-agent"
  log_group_name = aws_cloudwatch_log_group.ngrinder.name
}

resource "aws_cloudwatch_log_stream" "ngrinder_service_connect" {
  name           = "${var.project_name}-service-connect"
  log_group_name = aws_cloudwatch_log_group.ngrinder_service_connect.name
}
