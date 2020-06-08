resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "random_password" "grafana_password" {
  length = 10
  special = false
}

resource "kubernetes_secret" "grafana_admin_password" {
  metadata {
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    name      = "grafana-admin-password"
  }

  data = {
    password = random_password.grafana_password.result
  }
}

resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus-operator"
  version    = "8.14.0"
  timeout    = 600
  wait       = true

  set_sensitive {
    name = "grafana.adminPassword"
    value = random_password.grafana_password.result
  }

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      grafana_hostname = "grafana.parker.gg"
      storage_class    = var.storage_class
    })
  ]
}