output "role_definition_id" {
  value       = azurerm_role_definition.roledef.role_definition_id
  description = "The role definition id"
}
output "resourceId" {
  value       = azurerm_role_definition.roledef.role_definition_resource_id
  description = "the resource id of this role"
}
output "id" {
  value       = azurerm_role_definition.roledef.role_definition_id
  description = "The role definition id, again"
}
