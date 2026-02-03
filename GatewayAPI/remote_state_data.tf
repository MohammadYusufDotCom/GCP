##### remote state config ####
data "terraform_remote_state" "gke_state" {
  backend = "gcs"
  config = {
    bucket = "terraform"
    prefix = "terraform/gke_state"
  }
}

# Fetch the current project and credentials
data "google_client_config" "default" {
}

data "google_container_cluster" "primary" {
  name     = data.terraform_remote_state.gke_state.outputs.cluster_name
  location = data.terraform_remote_state.gke_state.outputs.cluster_location
}

data "google_compute_address" "gke_lb_static_ip" {
  name = data.terraform_remote_state.gke_state.outputs.static_ip_name
  # address = data.terraform_remote_state.gke_state.outputs.static_ip_address
}

data "google_certificate_manager_certificates" "gke_cert_manager" {
  # name     = data.terraform_remote_state.gke_state.outputs.cert_manager_name
  region = var.region
}

output "cert_manager_name" {
  value = data.terraform_remote_state.gke_state.outputs.cert_manager_name
}
