resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "nginx_ingress" {
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "nginx-ingress"
  version    = "1.36.2"
  namespace  = kubernetes_namespace.nginx_ingress.metadata[0].name
  name       = "nginx-ingress"

  values = [
    file("${path.module}/values.yaml")
  ]
}
