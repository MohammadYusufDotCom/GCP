## For creating a new static external IP for GKE LoadBalancer service
# resource "google_compute_address" "static_external_ip" {
#   name         = "${local.project_tags.project}-static-ip-${var.environment}"
#   network_tier = "STANDARD"
#   region       = var.region
#   description  = "Static external IP for GKE LoadBalancer in ${var.environment} environment"
#   labels       = local.common_tags
# }

## For using an existing static external IP for GKE LoadBalancer service
data "google_compute_address" "static_external_ip" {
  name = "api-dev-address"
}

output "static_ip_address" {
  value = google_compute_address.static_external_ip.address
}

output "static_ip_name" {
  value = google_compute_address.static_external_ip.name
}