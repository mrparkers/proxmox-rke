output "postgres_service" {
  value = "postgresql.${var.namespace}.svc.cluster.local"

  depends_on = [
    helm_release.postgresql
  ]
}

output "postgres_port" {
  value = "5432"

  depends_on = [
    helm_release.postgresql
  ]
}
