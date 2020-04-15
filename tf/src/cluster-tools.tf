// cert-manager

module "cert_manager" {
  source = "../modules/cert-manager"

  service_account_key_file = base64decode(google_service_account_key.dns_admin.private_key)
}

// external-dns

data "google_secret_manager_secret_version" "external_dns_public_ip_address" {
  provider = google-beta
  secret   = "public-ip-address"
}

module "external_dns" {
  source = "../modules/external-dns"

  ip_address               = data.google_secret_manager_secret_version.external_dns_public_ip_address.secret_data
  service_account_key_file = base64decode(google_service_account_key.dns_admin.private_key)
}

// nginx-ingress

module "nginx_ingress" {
  source = "../modules/nginx-ingress"
}
