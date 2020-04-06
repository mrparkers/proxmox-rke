resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

data "helm_repository" "mrparkers" {
  name = "mrparkers"
  url  = "https://mrparkers.github.io/charts"
}

resource "helm_release" "external_dns_target_admission" {
  chart      = "mrparkers/external-dns-target-admission"
  name       = "external-dns-target-admission"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  repository = data.helm_repository.mrparkers.name
  version    = "v0.2.0"

  wait = true

  set {
    name  = "ipAddress"
    value = var.ip_address
  }
}

resource "kubernetes_secret" "external_dns_service_account" {
  metadata {
    namespace = kubernetes_namespace.external_dns.metadata[0].name
    name      = "external-dns-service-account"
  }

  data = {
    "credentials.json" = var.service_account_key_file
  }
}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

resource "helm_release" "external_dns" {
  chart = "bitnami/external-dns"
  name  = "external-dns"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  repository = data.helm_repository.bitnami.name
  version    = "2.20.10"

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "google.serviceAccountSecret"
    value = kubernetes_secret.external_dns_service_account.metadata[0].name
  }
}
