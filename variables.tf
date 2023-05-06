# set specific variables here for your own deployment

/******************************
    REQUIRED TO CHANGE
******************************/
variable "organization_id" {
  type        = string
  description = "organization id required"
}
variable "billing_account" {
 type        = string
 description = "billing account required"
}


/*****************************
RECOMMENDED DEFAULTS - DO NOT CHANGE

unless you really really want to :)
*****************************/

variable "project_name" {
 type        = string
 default     = "vertex-project"
 description = "vertex workbench project to be created"
}


variable "folder_id" {
 type        = string
 default     = ""
 description = "A folder to create this project under. If none is provided, the project will be created under the organization"
}

variable "enable_apis" {
  description = "Which APIs to enable for this project."
  type        = list(string)
  default     = ["compute.googleapis.com", "cloudbilling.googleapis.com", "iam.googleapis.com", "notebooks.googleapis.com", "dns.googleapis.com", "artifactregistry.googleapis.com", "storage.googleapis.com"]
}

variable "labels" {
  description = "A set of key/value label pairs to assign to the project."
  type        = map(string)

  default = {
    environment = "development"
  }
}

variable "skip_delete" {
  description = " If true, the Terraform resource can be deleted without deleting the Project via the Google API."
  default     = "false"
}

variable "region" {
    description = "what region to deploy to"
    type        = string
    default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to create the instance in"
  type        = string
  default     = "us-central1-a"
}

variable "roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
  default     = ["roles/compute.admin", "roles/serviceAccountUser"]
}

variable "workbench_name" {
type          = string
description   = "name for workbench instance"
default       = "securevertex-notebook"
    
}

variable "machine_type" {
type          = string
description   = "compute engine machine type that workbench will run on"
default       = "c2d-standard-2"
    
}

variable "secure_boot" {
type          = bool
description   = "compute engine machine type that workbench will run on"
default       = true
    
}

variable "source_image_family" {
  description = "The OS Image family"
  type        = string
  default     = "common-cpu-notebooks-ubuntu-2004"
  #gcloud compute images list --project deeplearning-platform-release
}

variable "source_image_project" {
  description = "Google Cloud project with OS Image"
  type        = string
  default     = "deeplearning-platform-release"
}

variable "enable_gpu" {
type          = bool
description   = "sets gpu enablement on the compute instance for vertex workbench"
default       = false
    
}

variable "boot_disk_type" {
type          = string
description   = "Possible disk types for notebook instances. Possible values are: DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD, PD_BALANCED, PD_EXTREME"
default       = "PD_SSD"
}

variable "boot_disk_size_gb" {
type          = string
description   = "The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). The minimum recommended value is 100 GB. If not specified, this defaults to 100."
default       = "100"
}

variable "data_disk_type" {
type          = string
description   = "Possible disk types for notebook instances. Possible values are: DISK_TYPE_UNSPECIFIED, PD_STANDARD, PD_SSD, PD_BALANCED, PD_EXTREME"
default       = "PD_SSD"
}

variable "data_disk_size_gb" {
type          = string
description   = "The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). The minimum recommended value is 100 GB. If not specified, this defaults to 100."
default       = "100"
}

variable "no_remove_data_disk" {
type          = bool
description   = "If true, the data disk will not be auto deleted when deleting the instance."
default       = false
}

variable "disk_encryption" {
type          = string
description   = "Disk encryption method used on the boot and data disks, defaults to GMEK. Possible values are: DISK_ENCRYPTION_UNSPECIFIED, GMEK, CMEK"
default       = "GMEK"
}

variable "no_public_ip" {
type          = bool
description   = "No public IP will be assigned to this instance"
default       = false 
}

variable "no_proxy_access" {
type          = bool
description   = "The notebook instance will not register with the proxy"
default       = false 
}


/*****************************
NOT USED IN THIS TEMPLATE BUT ARE CONFIGURABLE FOR VERTEX AI WORKBENCH

variable "kms_key" {
type          = string
description   = "The KMS key used to encrypt the disks, only applicable if diskEncryption is CMEK. Format: projects/{project_id}/locations/{location}/keyRings/{key_ring_id}/cryptoKeys/{key_id}"

}

variable "project_id" {
 type        = string
 default     = "${organization_id}-vertex-project"
 description = "globally unique id of vertex workbench project to be created"
}

variable "cloud_storage_bucket_name" {
 type        = string
 default     = "${data_project_id}-vpc-sc-storage-bucket"
 description = "globally unique name of cloud storage bucket to be created"
}
variable "create_default_access_policy" {
 type        = bool
 default     = false
 description = "Whether a default access policy needs to be created for the organization. If one already exists, this should be set to false."
}


*****************************/

