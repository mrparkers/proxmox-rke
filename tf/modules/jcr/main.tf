resource "kubernetes_namespace" "jcr" {
  metadata {
    name = "jcr"
  }
}

resource "random_password" "admin_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "postgres_password" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "helm_release" "jcr" {
  chart      = "jfrog/artifactory-jcr"
  name       = "jcr"
  namespace  = kubernetes_namespace.jcr.metadata[0].name
  repository = "https://repo.chartcenter.io"
  version    = "3.2.0"

  wait    = true
  timeout = 600

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      admin_password    = random_password.admin_password.result
      postgres_password = random_password.postgres_password.result
    })
  ]
}
