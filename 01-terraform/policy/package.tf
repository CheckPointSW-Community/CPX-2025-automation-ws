resource "checkpoint_management_package" "terraform_AutoScale" {
  name = "terraform_AutoScale"
  color = "orange"
  threat_prevention = true
  access = true
  #
  # For autoscaling we can't be sure what target will be used as the list can grow and shrink over time
  #
  lifecycle {
    ignore_changes = [installation_targets]
  }
}
