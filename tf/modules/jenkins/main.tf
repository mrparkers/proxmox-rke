resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  chart      = "jenkins"
  name       = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name
  repository = "https://charts.jenkins.io"
  version    = "3.11.0"

  wait = true

  values = [
    templatefile("${path.module}/values.yaml", {

    })
  ]
}

resource "kubernetes_config_map" "jcasc_config" {
  metadata {
    name      = "jenkins-jenkins-jcasc-config"
    namespace = helm_release.jenkins.namespace

    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-controller"
      "app.kubernetes.io/managed-by" = "Terraform"
      "jenkins-jenkins-config"       = "true"
    }
  }
  data = {
    "jcasc-default-config.yaml.yaml" = templatefile("${path.module}/jcasc.yaml.tpl", {})
  }
}
