resource "google_project_service" "secretmanager" {
  service = "secretmanager.googleapis.com"
}
