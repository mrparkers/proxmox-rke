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
