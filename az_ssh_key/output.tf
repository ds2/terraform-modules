output "id" {
  value = azurerm_ssh_public_key.key.id
}
output "pubkey" {
  value = try(tls_private_key.ssh[0].public_key_openssh, "")
}
output "privkey" {
  value     = try(tls_private_key.ssh[0].private_key_openssh, "")
  sensitive = true
}
output "privkey_pkcs8" {
  value     = try(tls_private_key.ssh[0].private_key_pem_pkcs8, "")
  sensitive = true
}
output "name" {
  value = azurerm_ssh_public_key.key.name
}
