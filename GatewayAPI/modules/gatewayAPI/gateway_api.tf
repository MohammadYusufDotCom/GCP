resource "kubernetes_manifest" "gatewayApi_menifest" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"
    metadata = {
      name      = "gateway-api-regional"
      namespace = var.namespace
    }
    spec = {
      gatewayClassName = "gke-l7-regional-external-managed"
      listeners = [
        {
          name     = "http"
          protocol = "HTTP"
          port     = 80
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
        },
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          tls = {
            mode = "Terminate"
            options : {
              # "minimumTLSVersion" = "TLS1_2"
              "networking.gke.io/cert-manager-certs" = var.cert_manager_name #data.terraform_remote_state.gke_state.outputs.cert_manager_name
            }
            #certificateRefs = [ # Referencing a TLS certificate managed by GKE Secret Manager
            #  {
            #     name = "my-tls-cert"
            #  }
            #]
          }
          allowedRoutes = {
            namespaces = {
              from = "All"
            }
          }
        }
      ]
      addresses = [
        {
          type  = "NamedAddress"
          value = var.static_ip_name #data.google_compute_address.gke_lb_static_ip.name
        }
      ]
    }
  }
  # depends_on = [var.namespace_id]
}
