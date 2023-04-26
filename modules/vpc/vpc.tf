# this template creates the network for the workbench instance to live in
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"

    project_id   = var.project_id
    network_name = "securevertex-vpc"
    routing_mode = "REGIONAL"
    shared_vpc_host = false
    auto_create_subnetworks = false


    subnets = [
        {
            subnet_name               = "securevertex-subnet-a"
            subnet_ip                 = "10.10.10.0/24"
            subnet_region             = "us-central-1"
            subnet_private_access     = "false"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_30_SEC"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        },
        {
            subnet_name               = "securevertex-subnet-b"
            subnet_ip                 = "10.10.20.0/24"
            subnet_region             = "us-central-1"
            subnet_private_access     = "false"
            subnet_flow_logs          = "true"
            subnet_flow_logs_interval = "INTERVAL_30_SEC"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        }
    ]


}




