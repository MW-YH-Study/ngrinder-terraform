module "ngrinder-efs" {
  source = "./modules/single-efs"

  creation_token = "ngrinder"
}

module "prometheus-efs" {
  source = "./modules/single-efs"

  creation_token = "prometheus"
}

module "grafana-efs" {
  source = "./modules/single-efs"

  creation_token = "grafana"
}
