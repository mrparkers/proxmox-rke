resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "kubernetes_secret" "github" {
  metadata {
    name      = "jenkins-credential-github"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-controller"
      "app.kubernetes.io/managed-by" = "Terraform"
      "jenkins.io/credentials-type"  = "usernamePassword"
    }
    annotations = {
      "jenkins.io/credentials-description" = "GitHub Credentials"
    }
  }

  type = "Opaque"

  data = {
    username = "mrparkers"
    password = var.github_pat
  }
}

resource "kubernetes_secret" "github_pat" {
  metadata {
    name      = "jenkins-credential-github-pat"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-controller"
      "app.kubernetes.io/managed-by" = "Terraform"
      "jenkins.io/credentials-type"  = "secretText"
    }
    annotations = {
      "jenkins.io/credentials-description" = "GitHub PAT"
    }
  }

  type = "Opaque"

  data = {
    text = var.github_pat
  }
}

resource "kubernetes_config_map" "jcasc_config" {
  metadata {
    name      = "jenkins-jenkins-jcasc-config"
    namespace = kubernetes_namespace.jenkins.metadata[0].name

    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-controller"
      "app.kubernetes.io/managed-by" = "Terraform"
      "jenkins-jenkins-config"       = "true"
    }
  }
  data = {
    "jcasc-default-config.yaml.yaml" = templatefile("${path.module}/jcasc.yaml.tpl", {
      github_pat_secret_name = kubernetes_secret.github_pat.metadata[0].name
    })
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
    templatefile("${path.module}/values.yaml", {})
  ]

  depends_on = [
    kubernetes_config_map.jcasc_config,
    kubernetes_secret.github,
    kubernetes_secret.github_pat
  ]
}
