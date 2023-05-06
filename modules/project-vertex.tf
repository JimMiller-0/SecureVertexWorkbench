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
  folder_id           = var.folder_id
  labels              = var.labels
  name                = var.project_name
  project_id            = "${var.project_name}-${random_id.random_suffix.hex}"

  // Only one of `org_id` or `folder_id` may be specified, so we prefer the folder here.
  // Note that `organization_id` is required, making this safe.
  org_id = var.folder_id == "" ? var.organization_id : var.folder_id

  skip_delete = var.skip_delete
}

// Enable the requested APIs. APIs are set in the tfvars file
resource "google_project_service" "gcp_apis" {
  count   = length(var.enable_apis)
  project = google_project.project.id
  service = element(var.enable_apis, count.index)
}