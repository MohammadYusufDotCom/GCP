resource "kubernetes_manifest" "http_route_manifest" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    kind         = "HTTPRoute"
    metadata = {
      name = "https-route"
      # namespace = var.namespace
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
          # hostnames = [
          #   "example.com",
          #   "www.example.com"
          # ]
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/test"
              }
            }
          ]
          filters = [
            {
              type = "URLRewrite"
              urlRewrite = {
                path = {
                  type               = "ReplacePrefixMatch"
                  replacePrefixMatch = "/"
                }
              }
            }
          ]
          backendRefs = [
            {
              name   = "app-svc-1"
              port   = 80
              weight = 100
            }
          ]
        },

        {
          matches = [
            {
              headers = [
                {
                  # type  = "RegularExpression"
                  name  = "User-Agent"
                  value = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:146.0) Gecko/20100101 Firefox/146.0"
                }
              ]
            }
          ]
          filters = [
            {
              type = "ResponseHeaderModifier"
              responseHeaderModifier = {
                add = [
                  {
                    name  = "custom-response-header"
                    value = "weighted-backend"
                  }
                ]
              }
            }
          ]
          backendRefs = [
            {
              name   = "app-svc-1"
              port   = 80
              weight = 50
            },
            {
              name   = "app-svc-2"
              port   = 80
              weight = 50
            }
          ]
        },

        {
          filters = [
            {
              type = "ResponseHeaderModifier"
              responseHeaderModifier = {
                add = [
                  {
                    name  = "header"
                    value = "app-2-backend"
                  }
                ]
              }
            }
          ]
          backendRefs = [
            {
              name   = "app-svc-2"
              weight = 100
              port   = 80
            }
          ]
        }


      ]

    }
  }
}

