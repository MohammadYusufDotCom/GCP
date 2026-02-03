locals {
  my_domain = {
    domain           = "yusuf.com"
    dns_managed_zone = "yusuf-com"
  }

  project_tags = {
    project = "prod-gke"
  }
  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = var.project_id
  }
}