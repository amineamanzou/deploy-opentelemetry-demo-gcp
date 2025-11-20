resource "google_container_cluster" "oteldemo" {
  name       = var.cluster_name
  location   = var.region
  network    = google_compute_network.oteldemo.id
  subnetwork = google_compute_subnetwork.oteldemo.name

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  node_locations = var.zones

  ip_allocation_policy {}
}

resource "google_container_node_pool" "primary" {
  name     = "primary"
  location = var.region
  cluster  = google_container_cluster.oteldemo.name

  node_config {
    machine_type = var.node_machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  node_count = var.node_count_per_zone
}
