resource "google_service_account" "github" {
  account_id   = "oteldemo-github"
  display_name = "GitHub Actions"
}

resource "google_project_iam_member" "gke_admin" {
  project = data.google_project.target_project.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "secret_admin" {
  project = data.google_project.target_project.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "dns_admin" {
  project = data.google_project.target_project.project_id
  count   = length(var.base_domain) > 0 ? 1 : 0
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.github.email}"
}
