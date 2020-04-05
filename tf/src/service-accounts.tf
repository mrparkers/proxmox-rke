resource "google_service_account" "dns_admin" {
  account_id   = "dns-admin"
  display_name = "DNS Admin"
}

resource "google_project_iam_member" "dns_admin_dns_admin" {
  member = "serviceAccount:${google_service_account.dns_admin.email}"
  role   = "roles/dns.admin"
}

resource "google_project_iam_member" "dns_admin_viewer" {
  member = "serviceAccount:${google_service_account.dns_admin.email}"
  role   = "roles/viewer"
}

resource "google_service_account_key" "dns_admin" {
  service_account_id = google_service_account.dns_admin.name

  depends_on = [
    google_project_iam_member.dns_admin_dns_admin,
    google_project_iam_member.dns_admin_viewer,
  ]
}
