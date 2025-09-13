resource "google_compute_global_address" "ingress_ip" {
  name = var.ingress_static_ip_name
}
