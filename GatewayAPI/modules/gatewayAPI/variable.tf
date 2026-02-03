variable "namespace" {
  description = "Kubernetes namespace for deployments"
  type        = string
}
# variable "namespace_id" {
#   description = "The ID of the namespace"
#   type        = string
# }

variable "cert_manager_name" {
  description = "Name of certificate manager"
  type        = string
}

variable "static_ip_name" {
  description = "Name of the static IP address"
  type        = string
}