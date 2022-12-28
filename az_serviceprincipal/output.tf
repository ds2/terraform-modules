output "principalPw" {
  value       = azuread_service_principal_password.pw.value
  description = "the generated password for this principal"
  sensitive   = true
}

output "object_id" {
  value       = azuread_service_principal.principal.object_id
  description = "the object_id of the principal"
}
