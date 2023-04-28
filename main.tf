
/*************************************
    Vertex AI Workbench Instance

    all variables and their defaults can be
    can be found in variables.tf under
    the root directory
************************************/
resource "google_notebooks_instance" "notebook_instance_vm" {
  provider = google

  name         = var.name #default: securevertex-notebook
  location     = "${var.region}-a" #default: us-central-1
  machine_type = var.machine_type #default: c2d-standard-2 (2 vCPU, 8GB RAM)

/**
  vm_image {
    project      = var.vm_image_project
    image_family = var.vm_image_image_family
  }
**/

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

  service_account = length(var.service_account_email) > 0 ? var.service_account_email : local.compute_engine_service_account 

  install_gpu_driver = var.enable_gpu #default: false

  boot_disk_type      = var.boot_disk_type #default: PD_SSD
  boot_disk_size_gb   = var.boot_disk_size_gb #default 100 GB
  data_disk_type      = var.data_disk_type
  data_disk_size_gb   = var.data_disk_size_gb
  no_remove_data_disk = var.retain_disk

  no_public_ip    = var.no_public_ip #default: false
  no_proxy_access = false

  network = data.google_compute_network.notebook_network.self_link
  subnet  = length(var.notebook_sub_network_self_link) > 0 ? var.notebook_sub_network_self_link : element(data.google_compute_network.notebook_network.subnetworks_self_links, 0)

  post_startup_script = local.post_startup_script_url

  labels = merge(local.required_labels, var.labels)

  metadata = (
    var.disable_downloads && var.block_project_wide_ssh_keys ? #Check both of these together to not force rebuild of existing notebooks
    {
      terraform                  = "true"
      proxy-mode                 = "service_account"
      notebook-disable-downloads = true
      block-project-ssh-keys     = true
    } :
    var.disable_downloads ?
    {
      terraform                  = "true"
      proxy-mode                 = "service_account"
      notebook-disable-downloads = true
    } :
    {
      terraform  = "true"
      proxy-mode = "service_account"
    }
  )
}