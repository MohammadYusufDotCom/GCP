module "namespace" {
  source    = "./modules/namespace"
  namespace = var.namespace
}

module "secrets" {
  source    = "./modules/secrets"
  namespace = var.namespace
  
  depends_on = [module.namespace]
}

module "deployments" {
  source    = "./modules/deployments"
  namespace = var.namespace

  ghcr_secret = module.secrets.ghcr_secret

  auth_secret         = module.secrets.auth_secret
  auth_version        = var.auth_version
  depends_on          = [module.namespace]
}

module "gateway_api" {
  source    = "./modules/gatewayAPI"
  namespace = var.namespace

  cert_manager_name = data.terraform_remote_state.gke_state.outputs.cert_manager_name
  static_ip_name    = data.google_compute_address.gke_lb_static_ip.name

  depends_on = [module.namespace]
}

module "health_check" {
  source = "./modules/healthCheck"
  namespace = var.namespace
  depends_on = [module.namespace]
}