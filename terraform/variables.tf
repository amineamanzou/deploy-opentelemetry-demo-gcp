variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "zones" {
  type    = list(string)
  default = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "cluster_name" {
  type    = string
  default = "oteldemo-gke"
}

variable "node_machine_type" {
  type    = string
  default = "e2-standard-4"
}

variable "node_count_per_zone" {
  type    = number
  default = 1
}

variable "base_domain" {
  type    = string
  default = ""
}

variable "ingress_static_ip_name" {
  type    = string
  default = "oteldemo-ingress-ip"
}
