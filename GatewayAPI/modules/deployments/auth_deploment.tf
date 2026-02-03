resource "kubernetes_deployment_v1" "auth_deployment" {
  metadata {
    name      = "auth"
    namespace = var.namespace
    labels = {
      app = "auth"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth"
        }
      }

      spec {
        container {
          image = "ghcr.io/maplegraph/auth:${var.auth_version}"
          name  = "auth"
          # command = [
          #   "/bin/bash",
          #   "-c",
          #   "sleep 5000"
          #   "echo \"<!DOCTYPE html><html><head><title>Host</title></head><body style='font-family:Arial;background:#1e1e2f;color:white;text-align:center;padding-top:50px;'><h1>I am from $(hostname) on /test </h1><button style='cursor:pointer; padding:10px 20px;font-size:16px;background:#4caf50;color:white;border:none;border-radius:5px;'>Click Me</button><h2>Created by Yusuf</h2></body></html>\" > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
          # ]
          port {
            container_port = 8080
            name           = "http"
            protocol       = "TCP"
          }
          volume_mount {
            name       = "auth-secret"
            mount_path = "/app/.env"
            sub_path   = ".env"
            read_only  = true
          }
          security_context {
            allow_privilege_escalation = true
          }
        }
        image_pull_secrets {
          name = var.ghcr_secret #kubernetes_secret.ghcr_secret.metadata[0].name
        }
        volume {
          name = "auth-secret"
          secret {
            secret_name = var.auth_secret #kubernetes_secret_v1.auth_secret.metadata[0].name
          }
        }
        security_context {
          run_as_user = 0
        }
      }
    }
  }
  #depends_on = [kubernetes_namespace_v1.dev_namespace]#, var.ghcr_secret.ghcr_secret_id, var.auth_secret]
}

resource "kubernetes_service_v1" "auth_service" {
  metadata {
    name      = "auth-svc"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment_v1.auth_deployment.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment_v1.auth_deployment] #, kubernetes_namespace_v1.dev_namespace]
}