# this template creates the necessary service account with least privleges for workbench

resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = var.description

}

resource "google_project_iam_member" "sa_iam" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.sa.email}"

}