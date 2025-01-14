resource "checkpoint_management_service_tcp" "healthcheck" {
      port = "8117"
      name = "AzureHealthCheck"
      color = "blue"
      match_for_any = false 
              }

resource "checkpoint_management_service_tcp" "tcp8090" {
      port = "8090"
      name = "TCP-8090"
      color = "blue"
      match_for_any = false
            }

resource "checkpoint_management_service_tcp" "tcp33890" {
      port = "33890"
      name = "TCP-33890"
      color = "blue"
      match_for_any = false
            }
