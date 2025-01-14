terraform {
   required_providers {
     checkpoint = {
       source = "checkpointsw/checkpoint"
#       version = "~> 1.1.0"
     }
   }
}

provider "checkpoint" {
  # Configuration options
/*
  # Smart-1 Cloud example
  server        = "chkp-jim-xxx-nxx22x11.maas.checkpoint.com"
  api_key       = "XYZbv4ZyxdM+SdtjRI8AmjA=="
  context       = "web_api"
  cloud_mgmt_id = "77zz4yxx-c457-4646-8e63-d67e55345af8"
  timeout       = "120"
*/
/*
  # On premises Management example  
  server        = "192.168.233.40"
  #api_key      = ""
  username      = "api_user"
  password      = "vpn123"
  #domain       = "Domain Name"
  context       = "web_api"
  timeout       = "120"
*/
}



module "policy" {
  source = "./policy"
}

output "pod_id_output" {
  value = module.policy.pod_id_output
  description = "Your random genereated pod ID"
  depends_on = [ module.policy ]
}

// Example 1 - Trigger the publish resource every time there is a change on any of the configuration files in a specific module
// Expression to use to hash all files in directory policy that is used by the policy module
locals {
  publish_triggers = [for filename in fileset(path.module, "policy/*.tf"): filesha256(filename)]
}

// Triggers publish if any of the hashes of the files in the policy directory changed.
resource "checkpoint_management_publish" "publish" {
  depends_on = [ module.policy ]
  triggers = local.publish_triggers
  run_publish_on_destroy = true
}

//Example 2 - Trigger the publish resource if version number is changed 
// Set the publish version number (this expression can be improved and made more intelligent)
#locals {
#  publish_version = [1]
#}

// Triggers publish if version number in publish changes
#resource "checkpoint_management_publish" "publish" {
#  depends_on = [ module.policy ]
#  triggers = local.publish_version
#}

/*
Needs to be updated with the install policy resource as it supports triggers from version 1.2 of the provider
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