## self managed certificate 
# resource "google_certificate_manager_certificate" "gke_cert_manager" {
#   name        = "${local.project_tags.project}-cert-manager"
#   description = "GKE Cert Manager Certificate for Gateway API"
#   location    = var.region
#   # scope = "DEFAULT"
#   self_managed {
#     pem_certificate = file("certs/app1.crt")
#     pem_private_key = file("certs/tls.key")
#   }
#   depends_on = [google_project_service.certificatemanager, time_sleep.wait_for_cert_api]
#   labels     = local.common_tags
# }

# output "cert_manager_name" {
#   description = "GKE Cert Manager Certificate name"
#   value       = google_certificate_manager_certificate.gke_cert_manager.name
# }

## google_certificate_manager_dns_authorization
resource "google_certificate_manager_dns_authorization" "dns_authorization" {
  project     = var.project_id
  name        = "auth-authorization"
  location    = var.region
  description = "dns authorization for dev env certificate management"
  domain      = local.my_domain.domain
}

## google manager certificate 
resource "google_certificate_manager_certificate" "gke_cert_manager" {
  name        = "managed-dns-cert"
  description = "regional managed certs"
  location    = var.region
  labels      = local.common_tags
  managed {
    domains = [
      local.my_domain.domain
      # google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.name
    ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.dns_authorization.id,
    ]
  }
}

output "cert_manager_name" {
  description = "GKE Cert Manager Certificate name"
  value       = google_certificate_manager_certificate.gke_cert_manager.name
}

output "record_name_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.name
}

output "record_type_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.type
}

output "record_data_to_insert" {
  value = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.data
}