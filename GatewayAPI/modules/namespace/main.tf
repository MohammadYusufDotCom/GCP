resource "kubernetes_namespace_v1" "dev_namespace" {
  metadata {
    annotations = {
      name = "dev"
    }

    labels = {
      mylabel = "dev"
    }

    name = var.namespace
  }
}
