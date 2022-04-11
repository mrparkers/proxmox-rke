resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "helm_release" "external_dns_target_admission" {
  chart      = "/Users/parker/Developer/mrparkers-charts/charts/external-dns-target-admission"
  name       = "external-dns-target-admission"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  repository = "https://mrparkers.github.io/charts"
  version    = "v0.4.0"

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

resource "helm_release" "external_dns" {
  chart = "external-dns"
  name  = "external-dns"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  version    = "2.20.10"

  wait = true

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "google.serviceAccountSecret"
    value = kubernetes_secret.external_dns_service_account.metadata[0].name
  }

  depends_on = [
    helm_release.external_dns_target_admission
  ]
}
