locals {
  use_dns = length(var.base_domain) > 0
}

resource "google_dns_managed_zone" "oteldemo" {
  count   = local.use_dns ? 1 : 0
  name    = "${var.cluster_name}-zone"
  dns_name = "${var.base_domain}."
}

resource "google_dns_record_set" "ingress" {
  count        = local.use_dns ? 1 : 0
  name         = "*.oteldemo.${var.project_id}.${var.base_domain}."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.oteldemo[0].name
  rrdatas      = [google_compute_global_address.ingress_ip.address]
}
