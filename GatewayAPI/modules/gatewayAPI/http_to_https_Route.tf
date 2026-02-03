resource "kubernetes_manifest" "http_to_https_route_manifest" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "http-to-https-route"
      namespace = var.namespace
    }
    spec = {
      parentRefs = [
        {
          name        = kubernetes_manifest.gatewayApi_menifest.manifest.metadata.name #"gateway-api-regional"
          sectionName = "http"
        }
      ]
      rules = [
        {
          filters = [
            {
              type = "RequestRedirect"
              requestRedirect = {
                scheme     = "https"
                statusCode = "302"
              }
            }
          ]
        }
      ]
    }
  }
  # depends_on = [var.namespace_id]
}