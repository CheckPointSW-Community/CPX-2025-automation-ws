# Terraform-CHKP-terraform-April22-2024-Demo - Terraform configuration to demonstrate Check Point security Infrastructure as code

You can find the latest Terraform executable at: https://www.terraform.io/downloads.html

You can finf the latest Check Point Terraform provider documentation at: https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs

Example Policy creation with the Check Point Terraform Provider

### Publish best options and practices
As of right now, Terraform does not provide native support for post publish and install-policy. There are a cople of diffrent ways to handle that:
- Out of band publish using
  - Python (publish.py)
  - shell (publish.bat)
  - publish executable from the Check Point provider source code to publish the changes see https://registry.terraform.io/providers/CheckPointSW/checkpoint/latest/docs#post-apply--destroy-scripts for details.

- Trigger field (best practice)
  
  From version 1.2 the provider was enhanced where a triggers field for resource install_policy, publish and logout was added for re-execution if there are any changes in this list
  ```hcl
  # Put the Check Point configuration in a sub folder and refer to is as a module
  module "chkp_policy" {
    source = "./chkp_policy"
  }
  
  # Activate the trigger if there is a change in the configuration files in the folder chkp_policy
  locals {
    publish_triggers = [for filename in fileset(path.module, "chkp_policy/*.tf"): filesha256(filename)]
  }
  
  # Make the publish resources dependent of the module and **trigger** it if there is a change in the   configuration files
  resource "checkpoint_management_publish" "publish" { 
    depends_on = [ module.policy ]
    triggers = local.publish_triggers
  }
  ```

- Avoid large bulk publishes

  From version 2.5.0 the provider was enhanced with support to auto publish mode using **auto_publish_batch_size** or via the **CHECKPOINT_AUTO_PUBLISH_BATCH_SIZE** environment variable to configure the number of batch size to automatically run publish.

  ```hcl
  # Check Point Provider source and version used terraform {
  required_providers {
    checkpoint = {
      source = "checkpointsw/checkpoint"
      version  = "~> 2.6.0" 
      }
    }
  }
  # Configure the Check Point Provider
  provider "checkpoint" {
    server   = "chkp-mgmt-srv.local"
    api_key = "Check Point admin api key"
    context  = "web_api“
    auto_publish_batch_size = “100”
  }
  ```

- Control publish post destroy
  
  From version 2.6.0 the provider was enhanced where a new flag was added **run_publish_on_destroy** to **checkpoint_management_publish** which indicates whether to run publish on destroy
  
  ```hcl
  # Make the publish resources dependent of the module and trigger it if there is a change in the   configuration files
  resource "checkpoint_management_publish" "publish" { 
    depends_on = [ module.policy ]
    triggers = local.publish_triggers
    run_publish_on_destroy = true
    }
  ```


You execute terraform with:
```
terraform init
terraform plan
terraform apply
```

remove everything with: 
```
terraform destroy
```
The terraform demo will create hosts, networks, services, custom applications, domain objects, cynamic objects, policy packages, layers and populate that policy package with rules.