resource "kubernetes_namespace" "drone" {
  metadata {
    name = "drone"
  }
}

resource "random_password" "drone_db_password" {
  length  = 12
  special = false
}

module "postgresql" {
  source = "../postgresql"

  namespace = kubernetes_namespace.drone.metadata[0].name
  database  = "drone"
  username  = "drone"
  password  = random_password.drone_db_password.result
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "drone" {
  chart      = "stable/drone"
  name       = "drone"
  namespace  = kubernetes_namespace.drone.metadata[0].name
  repository = data.helm_repository.stable.name
  version    = "2.7.2"

  wait = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      github_client_id     = var.github_client_id
      github_client_secret = var.github_client_secret

      postgres_user     = "drone"
      postgres_password = random_password.drone_db_password.result
      postgres_service  = "postgresql.drone.svc.cluster.local"
      postgres_port     = "5432"
      postgres_database = "drone"

      host = "drone.parker.gg"
      admin = "mrparkers"

      users = join(",", [
        "mrparkers",
        "pickjasmine"
      ])
    })
  ]

  depends_on = [
    module.postgresql
  ]
}
