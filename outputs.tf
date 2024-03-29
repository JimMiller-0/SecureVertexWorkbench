/**
 * Copyright 2019 Google LLC
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

/*
output "email" {
  description = "The service account email."
  value       = module.service_accounts.service_account.email
}

output "iam_email" {
  description = "The service account IAM-format email."
  value       = module.service_accounts.iam_email
}
*/

output "proxy_uri" {
    description = "The proxy endpoint that is used to access the Jupyter notebook. Only returned when the resource is in a PROVISIONED state. If needed you can utilize terraform apply -refresh-only to await the population of this value."
    value = google_notebooks_instance.vertex_workbench_instance.proxy_uri
}