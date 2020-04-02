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

resource "helm_release" "crds" {
  name      = "cert-manager-crds"
  namespace = kubernetes_namespace.cert_manager.metadata[0].name
  chart     = "${path.module}/charts/crds"
  wait      = true
}

resource "null_resource" "wait_for_crds" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
  depends_on = [
    helm_release.crds
  ]
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert_manager" {
  chart      = "jetstack/cert-manager"
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  repository = data.helm_repository.jetstack.name
  version    = "v0.14.1"

  wait = true

  depends_on = [
    helm_release.crds,
    null_resource.wait_for_crds
  ]
}
