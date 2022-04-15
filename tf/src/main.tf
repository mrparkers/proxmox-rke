terraform {
  backend "gcs" {}
}

provider "google" {
  project = "parker-gg"
  region  = "us-central1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "rke"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "rke"
  }
}
