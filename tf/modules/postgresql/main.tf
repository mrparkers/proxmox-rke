resource "helm_release" "postgresql" {
  chart      = "postgresql"
  name       = "postgresql"
  namespace  = var.namespace
  repository = "https://charts.bitnami.com/bitnami"
  version    = "8.9.0"

  set_sensitive {
    name  = "postgresqlPassword"
    value = var.password
  }

  set {
    name  = "postgresqlUsername"
    value = var.username
  }

  set {
    name  = "postgresqlDatabase"
    value = var.database
  }

  set {
    name  = "global.storageClass"
    value = var.storage_class
  }
}
