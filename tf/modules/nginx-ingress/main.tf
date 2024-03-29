locals {
  certificate_secret_name = "wildcard-certificate"
}

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx_ingress" {
  chart      = "nginx-ingress"
  name       = "nginx-ingress"
  repository = "https://charts.helm.sh/stable"
  version    = "1.36.2"
  namespace  = kubernetes_namespace.nginx_ingress.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.extraArgs.default-ssl-certificate"
    value = "${kubernetes_namespace.nginx_ingress.metadata[0].name}/${local.certificate_secret_name}"
  }

  set {
    name  = "controller.extraArgs.enable-ssl-passthrough"
    value = "true"
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
