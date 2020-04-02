data "google_secret_manager_secret_version" "cert_manager_service_account_key" {
  provider = google-beta
  secret = "dns-service-account-key"
}

module "cert_manager" {
  source = "../modules/cert-manager"

  service_account_key_file = data.google_secret_manager_secret_version.cert_manager_service_account_key.secret_data
}
