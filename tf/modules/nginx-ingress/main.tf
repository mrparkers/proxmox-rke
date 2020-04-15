locals {
  certificate_secret_name = "wildcard-certificate"
}

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

  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "${kubernetes_namespace.nginx_ingress.metadata[0].name}/${local.certificate_secret_name}"
  }

  depends_on = [
    helm_release.wildcard_certificate
  ]
}

resource "helm_release" "wildcard_certificate" {
  name      = "wildcard-certificate"
  namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
  chart     = "${path.module}/charts/wildcard-certificate"
  wait      = true

  set {
    name  = "certificateSecretName"
    value = local.certificate_secret_name
  }

  set {
    name  = "clusterIssuerName"
    value = var.cluster_issuer_name
  }
}
