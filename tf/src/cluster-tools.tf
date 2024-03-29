// ceph

module "ceph" {
  source = "../modules/ceph"
}

// cert-manager

module "cert_manager" {
  source = "../modules/cert-manager"

  service_account_key_file = base64decode(google_service_account_key.dns_admin.private_key)
}

// external-dns

data "google_secret_manager_secret_version" "external_dns_public_ip_address" {
  secret = "public-ip-address"
}

module "external_dns" {
  source = "../modules/external-dns"

  ip_address               = data.google_secret_manager_secret_version.external_dns_public_ip_address.secret_data
  service_account_key_file = base64decode(google_service_account_key.dns_admin.private_key)
}

// nginx-ingress

module "nginx_ingress" {
  source = "../modules/nginx-ingress"

  cluster_issuer_name = module.cert_manager.cluster_issuer_name
}

// drone

#data "google_secret_manager_secret_version" "drone_github_client_id" {
#  secret = "github-client-id"
#}
#
#data "google_secret_manager_secret_version" "drone_github_client_secret" {
#  secret = "github-client-secret"
#}

#module "drone" {
#  source = "../modules/drone"
#
#  github_client_id       = data.google_secret_manager_secret_version.drone_github_client_id.secret_data
#  github_client_secret   = data.google_secret_manager_secret_version.drone_github_client_secret.secret_data
#  postgres_storage_class = module.ceph.storage_class
#}

// prometheus / grafana

module "prometheus_operator" {
  source = "../modules/prometheus-operator"

  storage_class = module.ceph.storage_class
}

// sonarqube

#module "sonarqube" {
#  source = "../modules/sonarqube"
#}

// jfrog container registry

#module "jcr" {
#  source = "../modules/jcr"
#}

// jenkins

data "google_secret_manager_secret_version" "github_jenkins_pat" {
  secret = "github-jenkins-pat"
}

module "jenkins" {
  source = "../modules/jenkins"

  github_pat = data.google_secret_manager_secret_version.github_jenkins_pat.secret_data
}

// harbor

module "harbor" {
  source = "../modules/harbor"
}
