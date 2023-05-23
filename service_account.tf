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

# this template creates the necessary service account with least privleges for workbench

resource "google_service_account" "sa" {
  project      = google_project.vertex-project.project_id
  account_id   = "securevertex-sa"
  display_name = "securevertex-sa"

}

resource "google_project_iam_member" "sa_iam" {
  for_each = toset(var.roles) #default: [roles/compute.admin, roles/serviceAccountUser]  -- note that storage permission is added in the bucket iam binding

  project = google_project.vertex-project.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"

}

resource "google_service_account" "vpc-sc-tf-sa" {
  project = google_project.vertex-project.project_id
  account_id   = "vpc-sc-tf-sa"
  display_name = "VPC-SC Terraform Service Account"
}

resource "google_project_iam_member" "vpc-sc-tf-iam" {
  for_each = toset(var.vpc-tf-roles) #default: ["roles/serviceusage.serviceUsageAdmin", "roles/accesscontextmanager.policyAdmin", "roles/resourcemanager.organizationViewer", "roles/iam.organizationRoleViewer"]

  project = google_project.vertex-project.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vpc-sc-tf-sa.email}"

}