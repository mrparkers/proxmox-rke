resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_secret" "cert_manager_service_account" {
  metadata {
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
    name      = "cert-manager-service-account"
  }

  data = {
    "credentials.json" = var.service_account_key_file
  }
}

resource "helm_release" "cert_manager" {
  chart      = "cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  repository = "https://charts.jetstack.io"
  version    = "v1.6.0"

  wait = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

locals {
  letsencrypt_prod    = "https://acme-v02.api.letsencrypt.org/directory"
  letsencrypt_staging = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

resource "helm_release" "cluster_issuer" {
  name      = "gcp-cluster-issuer"
  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  chart     = "${path.module}/charts/cluster-issuer"
  wait      = true

  set {
    name  = "acmeServer"
    value = local.letsencrypt_prod
  }

  set {
    name  = "serviceAccountSecret"
    value = kubernetes_secret.cert_manager_service_account.metadata[0].name
  }

  set {
    name  = "serviceAccountSecretKey"
    value = "credentials.json"
  }

  depends_on = [
    helm_release.cert_manager
  ]
}
