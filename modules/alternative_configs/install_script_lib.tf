module "startup-script-lib" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
}

/** add to workbench instance 
metadata metadata = {
    startup-script        = module.startup-scripts.content
    startup-script-custom = file("${path.module}/files/startup-script-custom")


    other option:

    gcloud compute project-info add-metadata \
  --project PROJECT_ID \
  --metadata=enable-osconfig=TRUE
gcloud compute instances add-metadata VM_NAME \
  --metadata=enable-osconfig=TRUE

    */