output "storage_class" {
  value = local.storage_class

  depends_on = [
    helm_release.ceph_storage_class
  ]
}
