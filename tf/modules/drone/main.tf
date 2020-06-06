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

  namespace     = kubernetes_namespace.drone.metadata[0].name
  database      = "drone"
  username      = "drone"
  password      = random_password.drone_db_password.result
  storage_class = var.postgres_storage_class
}

resource "helm_release" "drone" {
  chart      = "drone"
  name       = "drone"
  namespace  = kubernetes_namespace.drone.metadata[0].name
  repository = "https://kubernetes-charts.storage.googleapis.com"
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

      host  = "drone.parker.gg"
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

resource "kubernetes_role" "drone_pipeline" {
  metadata {
    name      = "drone-pipeline"
    namespace = kubernetes_namespace.drone.metadata[0].name
  }

  rule {
    api_groups = [
      ""
    ]
    resources  = [
      "secrets"
    ]
    verbs      = [
      "create",
      "delete"
    ]
  }

  rule {
    api_groups = [
      ""
    ]
    resources  = [
      "pods",
      "pods/log"
    ]
    verbs      = [
      "get",
      "create",
      "delete",
      "list",
      "watch",
      "update"
    ]
  }
}

resource "kubernetes_role_binding" "drone_pipeline" {
  metadata {
    name      = "drone-pipeline"
    namespace = kubernetes_namespace.drone.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.drone_pipeline.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "drone-drone-pipeline"
    namespace = kubernetes_namespace.drone.metadata[0].name
  }
}
