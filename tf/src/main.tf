terraform {
  backend "gcs" {}
}

provider "google" {
  project = "parker-gg"
  region  = "us-central1"
}

provider "google-beta" {
  project = "parker-gg"
  region  = "us-central1"
}

provider "kubernetes" {
  config_context = "rke"
}

provider "helm" {
  kubernetes {
    config_context = "rke"
  }
}

resource "kubernetes_ingress" "hello_world" {
  metadata {
    name        = "hello-world"
    namespace   = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }
  spec {
    rule {
      host = "test.parker.gg"
      http {
        path {
          path = "/"
          backend {
            service_name = "hello-world"
            service_port = "5555"
          }
        }
      }
    }
  }
}
