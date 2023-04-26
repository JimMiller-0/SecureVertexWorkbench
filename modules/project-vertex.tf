// Create a basic project.
resource "google_project" "vertex-project" {
  billing_account     = var.billing_account
  folder_id           = var.folder_id
  labels              = var.labels
  name                = local.project_name

  // Only one of `org_id` or `folder_id` may be specified, so we prefer the folder here.
  // Note that `organization_id` is required, making this safe.
  org_id = var.folder_id == "" ? var.organization_id : var.folder_id

  project_id  = local.project_id
  skip_delete = var.skip_delete
}

// Enable the requested APIs. APIs are set in the tfvars file
resource "google_project_service" "gcp_apis" {
  count   = length(var.enable_apis)
  project = google_project.project.id
  service = element(var.enable_apis, count.index)
}