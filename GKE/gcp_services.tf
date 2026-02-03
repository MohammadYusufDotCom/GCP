resource "google_project_service" "certificatemanager" {
  project            = var.project_id
  service            = "certificatemanager.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "wait_for_cert_api" {
  depends_on      = [google_project_service.certificatemanager]
  create_duration = "120s"
}