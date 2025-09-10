data "azuread_client_config" "current" {}

# Retrieve domain information
data "azuread_domains" "doms" {
  only_initial = true
}
