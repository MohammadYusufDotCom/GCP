resource "kubernetes_manifest" "gcp_backend_policy" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "GCPBackendPolicy"
    metadata = {
      name      = "gateway-backend-policy"
      namespace = "default"
    }
    spec = {
      default = {
        sessionAffinity = {
          type         = "GENERATED_COOKIE"
          cookieTtlSec = 10
        }
      }
      targetRef = {
        group = ""
        kind  = "Service"
        name  = "app-svc-2"
      }
    }
  }
}