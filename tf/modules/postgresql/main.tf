data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

resource "helm_release" "postgresql" {
  chart      = "bitnami/postgresql"
  name       = "postgresql"
  namespace  = var.namespace
  repository = data.helm_repository.bitnami.name
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
}
