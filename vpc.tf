/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# this template creates the network for the workbench instance to live in
resource "google_compute_network" "vpc_network" {
    project_id   =  google_project.vertex-project.project_id
    name = "securevertex-vpc"
    routing_mode = "REGIONAL"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "securevertex-subnet-a" {
            name                          = "securevertex-subnet-a"
            ip_cidr_range                 = "10.10.10.0/24"
            region                        = var.region #default: us-central1
            private_ip_google_access      = "false"
            log_config {            
                aggregation_interval      = "INTERVAL_30_SEC"
                flow_sampling             = 0.7
                metadata                  = "INCLUDE_ALL_METADATA"
        }

 resource "google_compute_subnetwork" "securevertex-subnet-b" {
            name                          = "securevertex-subnet-b"
            ip_cidr_range                 = "10.10.20.0/24"
            region                        = var.region #default: us-central1
            private_ip_google_access      = "false"
            log_config {            
                aggregation_interval      = "INTERVAL_30_SEC"
                flow_sampling             = 0.7
                metadata                  = "INCLUDE_ALL_METADATA"
        }
    
resource "google_compute_firewall" "egress" {
  project            = google_project.vertex-project.project_id
  name               = "deny-all-egress"
  description        = "Block all egress"
  network            = google_compute_network.vpc_network.name
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
  network       = google_compute_network.vpc_network.name
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
  network            = google_compute_network.vpc_network.name
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
  network            = google_compute_network.vpc_network.name
  priority           = 998
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}

