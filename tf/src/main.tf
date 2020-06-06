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
  version = "1.2.1"

  kubernetes {
    config_context = "rke"
  }
}

output "test" {
  value = "hi"
}
