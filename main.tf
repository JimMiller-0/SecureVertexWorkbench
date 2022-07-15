# this template orchastrates the build  for work bench and all other components
provider "google" {
}

provider "google" {
    alias = "service"
    impersonate_service_account = google_service_account.terraform_service_account.email
}

resource "google_folder" "terraform_demo" {
  display_name = var.demo_folder_name
  parent = "organizations/${var.organization_id}"
}

resource "google_service_account" "terraform_service_account" {
  project = google_project.data_project.project_id
  account_id   = "terraform-service-account"
  display_name = "Terraform Service Account"
}

resource "google_organization_iam_member" "access_context_manager_admin" {
  org_id  = var.organization_id
  role    = "roles/accesscontextmanager.policyAdmin"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "organization_viewer" {
  org_id  = var.organization_id
  role    = "roles/resourcemanager.organizationViewer"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "organization_role_viewer" {
  org_id  = var.organization_id
  role    = "roles/iam.organizationRoleViewer"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}

resource "google_organization_iam_member" "service_usage_admin" {
  org_id  = var.organization_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}