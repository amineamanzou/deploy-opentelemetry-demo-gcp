resource "google_service_account" "github" {
  account_id   = "oteldemo-github"
  display_name = "GitHub Actions"
}

resource "google_project_iam_member" "gke_admin" {
  role   = "roles/container.admin"
  member = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "secret_admin" {
  role   = "roles/secretmanager.admin"
  member = "serviceAccount:${google_service_account.github.email}"
}

resource "google_project_iam_member" "dns_admin" {
  count  = length(var.base_domain) > 0 ? 1 : 0
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.github.email}"
}
