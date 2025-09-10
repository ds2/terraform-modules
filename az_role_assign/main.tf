resource "random_uuid" "idgen" {
}

resource "azurerm_role_assignment" "roleassign1" {
  name               = random_uuid.idgen.result
  scope              = var.scopeId
  role_definition_id = var.roleResourceId
  principal_id       = var.principalObjectId
  description        = var.description
}
