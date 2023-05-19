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



/*************************************
    Vertex AI Workbench Instance

    all variables and their defaults can be
    can be found in variables.tf under
    the root directory
************************************/ 
resource "google_notebooks_instance" "vertex_workbench_instance" {
  project      = google_project.vertex-project.project_id
  name         = var.workbench_name #default: securevertex-notebook
  location     = var.zone #default: us-central1-a
  machine_type = var.machine_type #default: c2d-standard-2 (2 vCPU, 8GB RAM)
  vm_image {
    project      = var.source_image_project #default: deeplearning-platform-release
    image_family = var.source_image_family #default: common-cpu-notebooks-ubuntu-2004
  }

  shielded_instance_config {
    enable_secure_boot          = var.secure_boot #default: true
    enable_integrity_monitoring = true
    enable_vtpm                 = true
  }

/*****************************************************
no GPU enabled on the workbench instance for this template. 
However the terraform would look something like this:


  dynamic "accelerator_config" {
    for_each = var.enable_gpu ? [1] : []
    content {
      core_count = var.accelerator_config_core_count
      type       = var.accelerator_config_type
    }
  }

  
******************************************************/



  install_gpu_driver = var.enable_gpu #default: false

  boot_disk_type      = var.boot_disk_type #default: PD_SSD
  boot_disk_size_gb   = var.boot_disk_size_gb #default 100 GB
  data_disk_type      = var.data_disk_type #default: PD_SSD
  data_disk_size_gb   = var.data_disk_size_gb #default: 100 GB
  no_remove_data_disk = var.no_remove_data_disk #default: false
  disk_encryption     = var.disk_encryption #default: GMEK

  no_public_ip    = var.no_public_ip #default: true
  no_proxy_access = var.no_proxy_access #default: false

  network = google_compute_network.vpc_network.id
  subnet  = google_compute_subnetwork.securevertex-subnet-a.id

  //post_startup_script = local.post_startup_script_url

  //labels = merge(local.required_labels, var.labels)

  metadata = {
    notebook-disable-root      = "true"
    notebook-disable-downloads = "true"
    notebook-disable-nbconvert = "true"
  }


depends_on = [google_storage_bucket.bucket, time_sleep.wait_for_org_policy]  
}

resource "null_resource" "set_secure_boot" {
  provisioner "local-exec" {
    command = <<EOF
    gcloud config set project ${google_project.vertex-project.project_id}
    gcloud compute instances stop ${google_notebooks_instance.vertex_workbench_instance.name} --zone ${var.zone}
    sleep 120
    gcloud compute instances update ${google_notebooks_instance.vertex_workbench_instance.name} --shielded-secure-boot --zone ${var.zone}
    gcloud compute instances start ${google_notebooks_instance.vertex_workbench_instance.name} --zone ${var.zone}
    gcloud compute instances update ${google_notebooks_instance.vertex_workbench_instance.name} --shielded-learn-integrity-policy --zone ${var.zone}
    EOF
  }
  depends_on = [google_notebooks_instance.vertex_workbench_instance]
}