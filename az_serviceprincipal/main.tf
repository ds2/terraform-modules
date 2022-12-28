# Create an application
resource "azuread_application" "app" {
  display_name = var.appName
  owners       = [data.azuread_client_config.current.object_id]
}

# Create a service principal
resource "azuread_service_principal" "principal" {
  application_id = azuread_application.app.application_id
  description    = var.description
  owners         = [data.azuread_client_config.current.object_id]
}

resource "time_rotating" "example" {
  rotation_days = var.pwRotationDays
}

resource "azuread_service_principal_password" "pw" {
  display_name         = "My Password?"
  service_principal_id = azuread_service_principal.principal.object_id
  rotate_when_changed = {
    rotation = time_rotating.example.id
  }
  end_date_relative = "${var.pwRotationDays * 24}h"
}

# Create a user
# resource "azuread_user" "usr" {
#   user_principal_name = "ExampleUser@${data.azuread_domains.doms.domains.0.domain_name}"
#   display_name        = "Example User"
#   password            = "..."
# }
