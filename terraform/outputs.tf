output "cluster_name" {
  value = google_container_cluster.oteldemo.name
}

output "region" {
  value = var.region
}

output "zones" {
  value = var.zones
}

output "ingress_ip" {
  value = google_compute_global_address.ingress_ip.address
}

output "dns_zone" {
  value = length(var.base_domain) > 0 ? google_dns_managed_zone.oteldemo[0].name : ""
}
