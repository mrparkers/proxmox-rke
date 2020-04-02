terraform {
  backend "gcs" {}
}

provider "kubernetes" {
  config_context = "rke"
}
