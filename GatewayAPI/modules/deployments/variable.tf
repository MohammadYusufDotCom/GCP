variable "namespace" {
  description = "Kubernetes namespace for deployments"
  type        = string
}

## Dependency IDs
variable "ghcr_secret" {
  description = "The ID of the GHCR Secret for dependency"
  type        = string
}

variable "auth_secret" {
  description = "The ID of the Auth Secret for dependency"
  type        = string
}


## Application image versions
variable "auth_version" {
  description = "Kubernetes namespace for deployments"
  type        = string
}