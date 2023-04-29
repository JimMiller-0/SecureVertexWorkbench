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
variable "folder_id" {
 type        = string
 default     = "${organization_id}-vpc-sc-terraform-demo"
 description = "unique name of demo folder to be created"
}
variable "project_id" {
 type        = string
 default     = "${organization_id}-vertex-project"
 description = "globally unique id of vertex workbench project to be created"
}

variable "project_name" {
 type        = string
 default     = "vertex-project"
 description = "vertex workbench project to be created"
}


/*****************************
RECOMMENDED DEFAULTS - DO NOT CHANGE

unless you really really want to :)
*****************************/
variable "enable_apis" {
  description = "Which APIs to enable for this project."
  type        = list(string)
  default     = ["compute.googleapis.com", "cloudbilling.googleapis.com", "iam.googleapis.com", "notebooks.googleapis.com", "dns.googleapis.com", "artifactregistry.googleapis.com"]
}

variable "region" {
    description = "what region to deploy to"
    type        = string
    default     = "us-central1"
}

variable "roles" {
  type        = list(string)
  description = "The roles that will be granted to the service account."
  default     = [role/compute.admin, role/serviceAccountUser]
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

variable "data_disk_size_gb" {
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


variable "enable_gpu" {
type          = bool
description   = "sets gpu enablement on the compute instance for vertex workbench"
default       = false
    
}

variable "kms_key" {
type          = string
description   = "The KMS key used to encrypt the disks, only applicable if diskEncryption is CMEK. Format: projects/{project_id}/locations/{location}/keyRings/{key_ring_id}/cryptoKeys/{key_id}"

}



*****************************/

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
