resource "kubernetes_secret_v1" "auth_secret" {
  metadata {
    name      = "auth-secret"
    namespace = var.namespace
  }

  data = {
    ".env" = <<EOF
    
    EOF
  }

  type = "Opaque"
}
