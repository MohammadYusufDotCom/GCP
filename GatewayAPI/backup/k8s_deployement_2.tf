resource "kubernetes_deployment_v1" "deployment_2" {
  metadata {
    name = "app-2"
    # namespace = var.namespace
    labels = {
      app = "my-app2"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app2"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app2"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "nginx-container"
          command = [
            "/bin/bash",
            "-c",
            "echo \"<!DOCTYPE html><html><head><title>Host</title></head><body style='font-family:Arial;background:#1e1e2f;color:white;text-align:center;padding-top:50px;'><h1>I am from $(hostname)</h1><button style='cursor:pointer; padding:10px 20px;font-size:16px;background:#4caf50;color:white;border:none;border-radius:5px;'>Click Me</button><h2>Created by Yusuf</h2></body></html>\" > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"
          ]
          port {
            container_port = 80
            name           = "http"
            protocol       = "TCP"
          }
        }
        image_pull_secrets {
          name = kubernetes_secret.ghcr_secret.metadata[0].name
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "service_2" {
  metadata {
    name = "app-svc-2"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.deployment_2.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}