terraform {
  required_version = ">= 0.13"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.10.0"
    }
    google = {
      source = "hashicorp/google"
      version = "4.16.0"
    }
  }
}
