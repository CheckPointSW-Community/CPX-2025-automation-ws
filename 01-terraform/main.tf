terraform {
   required_providers {
     checkpoint = {
       source = "checkpointsw/checkpoint"
     }
   }
}

provider "checkpoint" {
  alias   = "system_data_domain"
  context = "web_api"
  domain  = "System Data"
  timeout = "120"
  session_file_name = "system_data_domain_sid.json"
}

provider "checkpoint" {
  alias   = "user_domain"
  context = "web_api"
  domain  = "SMC User"
  timeout = "120"
  session_file_name = "user_domain_sid.json"
}

# This module will update administrators on a MDS or SmartCenter
module "admins" {
  source = "./system-data"
  providers = {
    checkpoint = checkpoint.system_data_domain
  }
}

## This module will update the security policy in a MDS domain or SmartCenter
module "policy" {
  source = "./policy"
  providers = {
    checkpoint = checkpoint.user_domain
  }
}

// Trigger the publish resource every time there is a change on any of the configuration files in a specific module
// Expression to use to hash all files in directory policy that is used by the policy module
locals {
  publish_trigger-policy = [for filename in fileset(path.module, "policy/*.tf"): filesha256(filename)]
  publish_trigger-admins = [for filename in fileset(path.module, "system-data/*.tf"): filesha256(filename)]
}

// Triggers publish if any of the hashes of the files in the policy directory changed.

resource "checkpoint_management_publish" "publish_admins" {
  depends_on = [module.admins]
  triggers   = flatten([local.publish_trigger-admins])

  run_publish_on_destroy = true
  provider = checkpoint.system_data_domain
}

resource "checkpoint_management_publish" "publish_policy" {
  depends_on = [module.policy]
  triggers   = flatten([local.publish_trigger-policy])

  run_publish_on_destroy = true
  provider = checkpoint.user_domain
}

resource "checkpoint_management_logout" "logout_admins" {
  depends_on = [checkpoint_management_publish.publish_admins]
  provider   = checkpoint.system_data_domain
}

resource "checkpoint_management_logout" "logout_policy" {
  depends_on = [checkpoint_management_publish.publish_policy]
  provider   = checkpoint.user_domain
}




/*
// Old unused code

provider "checkpoint" {
// Configuration options
  //domain = "System Data" # used when adding administrators
  //domain = "SMC User" # Default, used when updating security policy on SmartCenter

// Smart-1 Cloud example
  server        = "chkp-jim-xxx-nxx22x11.maas.checkpoint.com"
  api_key       = "XYZbv4ZyxdM+SdtjRI8AmjA=="
  context       = "web_api"
  cloud_mgmt_id = "77zz4yxx-c457-4646-8e63-d67e55345af8"
  timeout       = "120"
  
// On-premises Management example  
  server        = "192.168.233.40"
  #api_key      = ""
  username      = "api_user"
  password      = "vpn123"
  #domain       = "Domain Name"
  context       = "web_api"
  timeout       = "120"

}

//Example 2 - Trigger the publish resource if version number is changed 
// Set the publish version number (this expression can be improved and made more intelligent)
locals {
  publish_version = [1]
}

// Triggers publish if version number in publish changes
resource "checkpoint_management_publish" "publish" {
  depends_on = [ module.policy ]
  triggers = local.publish_version
}

// Needs to be updated with the install policy resource as it supports triggers from version 1.2 of the provider
variable "policy_install" {
  type    = bool
  default = false
  description = "Set to true to install policy"
}

resource "null_resource" "installpolicy" {
  count = var.policy_install ? 1: 0

  triggers = {
    version = "1"
}
  provisioner  "local-exec" {
  command = "/home/ubuntu/Terraform_Module_Test/installpolicy.sh"
  interpreter = ["/bin/bash"]
}
depends_on = [checkpoint_management_publish.publish]
}
*/