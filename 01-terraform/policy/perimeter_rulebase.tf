          resource "checkpoint_management_access_section" "jumpsection" {
              name = "Jump Host Access"
              position = {top = "top"}
              layer = "${checkpoint_management_package.terraform_Perimeter.name} Network"
             }
          
          resource "checkpoint_management_access_rule" "perimeterrule1" {
                enabled = true
                name = "Jump Host Rule"
                source = [ checkpoint_management_dns_domain.jumphost.name]
                destination = [ "Any" ]
                service = ["ssh", "https"]
                action = "Accept"
                content = [ "Any" ]
                install_on = [ "Policy Targets" ]
                time = [ "Any" ]
                vpn = "Any"
                layer = "${checkpoint_management_package.terraform_Perimeter.name} Network"
                action_settings = {
                  enable_identity_captive_portal = false
                  }
                track = {
                  accounting = false
	                alert = "none"
                  enable_firewall_session = true
                  per_connection = true
                  per_session = true
                  type = "Log"
                  }
                position = {below = checkpoint_management_access_section.jumpsection.name}
                                }

          resource "checkpoint_management_access_section" "accesssection" {
              name = "Perimeter Access"
              position = {above = checkpoint_management_access_rule.perimeterrule2.name}
              layer = "${checkpoint_management_package.terraform_Perimeter.name} Network"
             }

          resource "checkpoint_management_access_section" "cleanupsection" {
              name = "Cleanup Rules"
              position = {above = "Cleanup rule"}
              layer = "${checkpoint_management_package.terraform_Perimeter.name} Network"
              depends_on = [ checkpoint_management_access_rule.perimeterrule2, checkpoint_management_access_rule.allowrule3 ] 
             }

          resource "checkpoint_management_access_rule" "perimeterrule2" {
                enabled = true
                name = "Outbound Rule"
                source = [ checkpoint_management_network.vpc_local.name]
                destination = [ "Any" ]
                service = ["ssh", "https", "dns", "http", "ntp", "icmp-proto", "ftp"]
                action = "Apply Layer"
                content = [ "Any" ]
                install_on = [ "Policy Targets" ]
                time = [ "Any" ]
                vpn = "Any"
                inline_layer = checkpoint_management_access_layer.terraform_Perimeter_URLF.name
                layer = "${checkpoint_management_package.terraform_Perimeter.name} Network"
                track = {
                  accounting = false
	                alert = "none"
                  enable_firewall_session = true
                  per_connection = true
                  per_session = true
                  type = "None"
                  }
                position = {below = checkpoint_management_access_rule.perimeterrule1.name}
                lifecycle {
                   ignore_changes = [action] 
                }
                                }
          
