resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = "sonarqube"
  }
}

resource "random_password" "admin_password" {
  length  = 16
  special = false
}

resource "helm_release" "sonarqube" {
  chart      = "sonarqube"
  name       = "sonarqube"
  namespace  = kubernetes_namespace.sonarqube.metadata[0].name
  repository = "https://oteemo.github.io/charts"
  version    = "6.8.1"

  wait = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      admin_password = random_password.admin_password.result
    })
  ]
}
