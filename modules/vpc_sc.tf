
provider "google" {
  version = "~> 3.19.0"
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  policy  = module.org_policy.policy_id
  name    = "terraform_members"
  members = var.members
}

module "regular_service_perimeter_1" {
  source              = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy              = module.org_policy.policy_id
  perimeter_name      = "regular_perimeter_1"
  description         = "Perimeter shielding projects"
  resources           = ["1111111"]
  access_levels       = [module.access_level_members.name]
  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
  shared_resources    = {
    all = ["11111111"]
  }
}