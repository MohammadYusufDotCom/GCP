resource "kubernetes_manifest" "healthcheck" {
  for_each = toset(local.services)

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "HealthCheckPolicy"

    metadata = {
      name      = "${each.key}-healthcheck"
      namespace = var.namespace
    }

    spec = {
      default = {
        checkIntervalSec   = 30
        timeoutSec         = 10
        healthyThreshold   = 1
        unhealthyThreshold = 2

        logConfig = {
          enabled = false
        }

        config = {
          type = "HTTP"
          httpHealthCheck = {
            portSpecification = "USE_FIXED_PORT"
            port              = 8080
            requestPath       = "/api/public/${each.key}/v1/health"
          }
        }
      }

      targetRef = {
        group = ""
        kind  = "Service"
        name  = "${each.key}-svc"
      }
    }
  }
}
