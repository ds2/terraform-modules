data "azurerm_subscription" "primary" {
}

resource "random_uuid" "roledef" {
}

locals {
  has_scopes         = length(var.scopes) > 0
  role_scope         = local.has_scopes ? var.scopes[0] : data.azurerm_subscription.primary.id
  role_scopes        = local.has_scopes ? concat(var.scopes, [data.azurerm_subscription.primary.id]) : [data.azurerm_subscription.primary.id]
  role_scopes_sorted = sort(local.role_scopes)
}

resource "azurerm_role_definition" "roledef" {
  role_definition_id = random_uuid.roledef.result
  name               = var.name
  scope              = local.role_scope
  description        = var.description

  permissions {
    actions      = var.actions
    data_actions = var.dataActions
    not_actions  = var.notActions
  }

  assignable_scopes = local.role_scopes_sorted
}
