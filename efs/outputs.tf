output "ngrinder_efs_id" {
  value = module.ngrinder-efs.efs_id
}

output "prometheus_efs_id" {
  value = module.prometheus-efs.efs_id
}

output "grafana_efs_id" {
  value = module.grafana-efs.efs_id
}
