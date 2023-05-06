# this template creates the network for the workbench instance to live in
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"

    project_id   =  google_project.vertex-project.project_id
    network_name = "securevertex-vpc"
    routing_mode = "REGIONAL"
    shared_vpc_host = false
    auto_create_subnetworks = false


    subnets = [
        {
            subnet_name               = "securevertex-subnet-a"
            subnet_ip                 = "10.10.10.0/24"
            subnet_region             = var.region #default: us-central1
            subnet_private_access     = "false"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_30_SEC"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
        {
            subnet_name               = "securevertex-subnet-b"
            subnet_ip                 = "10.10.20.0/24"
            subnet_region             = var.region #default: us-central1
            subnet_private_access     = "false"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_30_SEC"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]


}

resource "google_compute_firewall" "egress" {
  project            = google_project.vertex-project.project_id
  name               = "deny-all-egress"
  description        = "Block all egress"
  network            = module.vpc.network_name
  priority           = 1000
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  deny {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "ingress" {
  project       = google_project.vertex-project.project_id
  name          = "deny-all-ingress"
  description   = "Block all Ingress"
  network       = module.vpc.network_name
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  deny {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "googleapi_egress" {
  project            = google_project.vertex-project.project_id
  name               = "allow-googleapi-egress"
  description        = "Allow connectivity to storage"
  network            = module.vpc.network_name
  priority           = 999
  direction          = "EGRESS"
  destination_ranges = ["199.36.153.8/30"]
  allow {
    protocol = "tcp"
    ports    = ["443", "8080", "80"]
  }
}

resource "google_compute_firewall" "www_egress" {
  project            = google_project.vertex-project.project_id
  name               = "allow-www-egress"
  description        = "Allow connectivity to web"
  network            = module.vpc.network_name
  priority           = 998
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

