variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1" # Mumbai region
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be emspty."
  }
}

variable "namespace" {
  description = "The Kubernetes namespace"
  type        = string
  default     = "default"
}

## Application image versions

variable "auth_version" {
  description = "Version of the auth image"
  type        = string
  default     = "latest"
}
