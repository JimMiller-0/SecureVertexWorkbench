# this template creates the necessary service account with least privleges for workbench

resource "google_storage_bucket_iam_binding" "notebook_gcs_binding" {
  role   = "roles/storage.admin"
  bucket = google_storage_bucket.notebook_bucket.name

  members = [
    "serviceAccount:${local.compute_engine_service_account}",
    "serviceAccount:${var.service_account_email}"
  ]
}

resource "google_notebooks_instance_iam_member" "notebook_instance_service_account_binding" {
  count = length(var.role_id) > 0 ? 1 : 0

  project       = google_notebooks_instance.notebook_instance_vm.project
  location      = google_notebooks_instance.notebook_instance_vm.location
  instance_name = google_notebooks_instance.notebook_instance_vm.name
  role          = var.role_id
  member        = "serviceAccount:${var.service_account_email}"
}