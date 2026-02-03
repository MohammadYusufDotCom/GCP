resource "kubernetes_manifest" "http_route_manifest" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    kind         = "HTTPRoute"
    metadata = {
      name      = "https-route"
      namespace = var.namespace
    }

    spec = {
      parentRefs = [
        {
          name        = kubernetes_manifest.gatewayApi_menifest.manifest.metadata.name #"gateway-api-regional"
          sectionName = "https"
        }
      ]

      rules = [

        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/api/public/auth"
              }
            }
          ]
          backendRefs = [
            {
              name   = "auth-svc"
              port   = 80
              weight = 100
            }
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/api/public/friday"
              }
            }
          ]
          backendRefs = [
            {
              name   = "friday-svc"
              port   = 80
              weight = 100
            }
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/api/public/employee"
              }
            }
          ]
          backendRefs = [
            {
              name   = "employee-svc"
              port   = 80
              weight = 100
            }
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/api/public/notification"
              }
            }
          ]
          backendRefs = [
            {
              name   = "notification-svc"
              port   = 80
              weight = 100
            }
          ]
        },
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]
          backendRefs = [
            {
              name   = "setup-svc"
              port   = 80
              weight = 100
            }
          ]
        }
      ]
    }
  }
}

