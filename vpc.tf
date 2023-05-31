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
    project  =  google_project.vertex-project.project_id
    name = "securevertex-vpc"
    routing_mode = "REGIONAL"
    auto_create_subnetworks = false
    depends_on = [time_sleep.wait_for_org_policy]  
}

resource "google_compute_subnetwork" "securevertex-subnet-a" {
            project  =  google_project.vertex-project.project_id
            name                          = "securevertex-subnet-a"
            ip_cidr_range                 = "10.10.10.0/28"
            region                        = var.region #default: us-central1
            private_ip_google_access      = "true"
            network                       = google_compute_network.vpc_network.name
            log_config {            
                aggregation_interval      = "INTERVAL_30_SEC"
                flow_sampling             = 0.7
                metadata                  = "INCLUDE_ALL_METADATA"
        }
            depends_on = [google_compute_network.vpc_network]  
}        

resource "google_compute_router" "vertex-vpc-router" {
  name    = "vertex-vpc-router"
  network = google_compute_network.vpc_network.name
  region = var.region  #default: us-central1
  project  =  google_project.vertex-project.project_id
  depends_on = [google_compute_network.vpc_network]  
}  


resource "google_compute_router_nat" "vertex-nat" {
  name                                = "vertex-nat"
  project                             = google_project.vertex-project.project_id
  router                              = google_compute_router.vertex-vpc-router.name
  region                              = var.region #default: us-central1
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_dynamic_port_allocation      = true
  enable_endpoint_independent_mapping = false

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  depends_on = [google_compute_network.vpc_network]  
}
