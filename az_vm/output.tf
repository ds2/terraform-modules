output "ipAddress" {
  value = azurerm_network_interface.if01.private_ip_address
}
output "ipAddresses" {
  value = azurerm_network_interface.if01.private_ip_addresses
}
output "macAddress" {
  value = azurerm_network_interface.if01.mac_address
}
output "internalDomainSuffix" {
  value = azurerm_network_interface.if01.internal_domain_name_suffix
}
