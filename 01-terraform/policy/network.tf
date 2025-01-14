resource "checkpoint_management_network" "vpc_local" {
      subnet4 = "10.30.0.0"
      mask_length4 = "16"
      name = "terraform-Local-vpc"
      color = "red"
      nat_settings = {
        auto_rule = true
        method = "hide"
        hide_behind = "gateway"
        install_on = "All"
      }
        }
