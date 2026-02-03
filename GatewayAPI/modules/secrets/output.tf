output "ghcr_secret" {
  description = "The ID of the GHCR Secret"
  value       = kubernetes_secret.ghcr_secret.metadata[0].name
}

output "auth_secret" {
  description = "The ID of the Auth Secret"
  value       = kubernetes_secret_v1.auth_secret.metadata[0].name
}