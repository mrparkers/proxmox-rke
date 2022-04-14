resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
  }
}

resource "random_password" "admin_password" {
  length = 16
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "helm_release" "harbor" {
  chart      = "harbor"
  name       = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  repository = "https://helm.goharbor.io"
  version    = "1.8.2"

  wait = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {

    })
  ]

  set_sensitive {
    name  = "harborAdminPassword"
    value = random_password.admin_password.result
  }

  set_sensitive {
    name  = "database.internal.password"
    value = random_password.db_password.result
  }
}
