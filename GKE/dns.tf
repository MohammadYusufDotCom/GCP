# certificate mapping and authenticaion
resource "google_dns_record_set" "gke_certificate_dns_authorication_mapping" {
  managed_zone = local.my_domain.dns_managed_zone
  name         = "${google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record[0].name}"
  type         = google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.type
  ttl          = 300
  rrdatas = [
    google_certificate_manager_dns_authorization.dns_authorization.dns_resource_record.0.data
    ]
}

# Ip mappping 
resource "google_dns_record_set" "gke_lb_mapping" {
  managed_zone = local.my_domain.dns_managed_zone
  name         = "${local.my_domain.domain}."#google_certificate_manager_dns_authorization.dns_authorization.domain
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_address.static_external_ip.address]
}

