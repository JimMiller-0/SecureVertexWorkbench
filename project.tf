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

// Create a basic project.
resource "google_project" "vertex-project" {
  billing_account     = var.billing_account
  org_id              = var.organization_id
  //folder_id           = var.folder_id
  labels              = var.labels
  name                = var.project_name
  project_id            = "${var.project_name}-${random_id.random_suffix.hex}"

  // Only one of `org_id` or `folder_id` may be specified, so we prefer the folder here.
  // Note that `organization_id` is required, making this safe.
  //org_id = var.folder_id == "" ? var.organization_id : var.folder_id

  skip_delete = var.skip_delete
}

resource "random_id" "random_suffix" {
  byte_length = 4
}

// Enable the requested APIs. APIs are set in the variables file
resource "google_project_service" "gcp_apis" {
  count   = length(var.enable_apis)
  project = google_project.vertex-project.project_id
  service = element(var.enable_apis, count.index)
}

// Set Org policies to allow Vertex AI Workbench configuration

module "org-policy-requireShieldedVm" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = google_project.vertex-project.project_id
  constraint  = "compute.requireShieldedVm"
  policy_type = "boolean"
  enforce     = false
}

module "org-policy-vmExternalIpAccess" {
  source      = "terraform-google-modules/org-policy/google"
  policy_for  = "project"
  project_id  = google_project.vertex-project.project_id
  constraint  = "compute.vmExternalIpAccess"
  policy_type = "list"
  enforce     = false
}

resource "time_sleep" "wait_for_org_policy" {
  depends_on      = [module.org-policy-requireShieldedVm, module.org-policy-vmExternalIpAccess, google_project_service.gcp_apis]
  create_duration = "300s"
}