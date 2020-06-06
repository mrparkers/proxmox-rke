locals {
  storage_class = "rook-ceph-block"
}

resource "kubernetes_namespace" "rook_ceph" {
  metadata {
    name = "rook-ceph"
  }
}

resource "helm_release" "rook_ceph" {
  chart      = "rook-ceph"
  name       = "rook-ceph"
  namespace  = kubernetes_namespace.rook_ceph.metadata[0].name
  repository = "https://charts.rook.io/release"
  version    = "v1.3.4"

  wait = true
}

resource "helm_release" "ceph_cluster" {
  name  = "ceph-cluster"
  namespace  = kubernetes_namespace.rook_ceph.metadata[0].name
  chart = "${path.module}/charts/ceph-cluster"

  wait = true
}

// ceph cluster takes a while to provision, so wait 2-3 minutes before creating the storage class
resource "null_resource" "wait_for_ceph_cluster" {
  provisioner "local-exec" {
    command = "sleep 180"
  }

  depends_on = [
    helm_release.ceph_cluster
  ]
}

resource "helm_release" "ceph_storage_class" {
  name  = "ceph-storage-class"
  namespace  = kubernetes_namespace.rook_ceph.metadata[0].name
  chart = "${path.module}/charts/ceph-storage-class"

  wait = true

  set {
    name  = "storage_class"
    value = local.storage_class
  }
}
