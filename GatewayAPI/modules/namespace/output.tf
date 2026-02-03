output "namespace_id" {
  description = "The ID of the namespace"
  value       = kubernetes_namespace_v1.dev_namespace.id
}