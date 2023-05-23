resource "google_access_context_manager_access_policy" "default" {
  provider = google.service
  count = var.create_default_access_policy ? 1 : 0
  parent = "organizations/${var.organization_id}"
  title  = "Default Org Access Policy"
}

resource "google_access_context_manager_access_policy" "vertex_project_policy" {
  provider = google.service
  parent = "organizations/${var.organization_id}"
  title  = "vertex project policy"
  scopes = ["projects/${google_project.vertex-project.number}"]

}

resource "google_access_context_manager_access_levels" "vertex_ip_allow" {
  provider = google.service
  parent = "accessPolicies/${google_access_context_manager_access_policy.vertex_project_policy.name}"
  access_levels {
    name   = "accessPolicies/${google_access_context_manager_access_policy.vertex_project_policy.name}/accessLevels/vertex_ip_allow"
    title  = "vertex_ip_allow"
    basic {
      conditions {
        ip_subnetworks = ["${var.ip_allow}/32"]
      }
    }
  }
}




resource "google_access_context_manager_service_perimeter" "restrict_vertex_project" {
  provider = google.service
  parent = "accessPolicies/${google_access_context_manager_access_policy.vertex_project_policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.vertex_project_policy.name}/servicePerimeters/restrict_vertex_project"
  title  = "restrict_vertex_project"
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    restricted_services = var.restricted_apis
    resources = ["projects/${google_project.vertex-project.number}"]
    access_levels = ["${google_access_context_manager_access_levels.vertex_ip_allow.id}"]
    vpc_accessible_services {
        enable_restriction = false        
    }

  }
}