output "name" {
  value = azurerm_storage_account.storageaccount.name
}

output "id" {
  value = azurerm_storage_account.storageaccount.id
}

output "endpoint1" {
  value = azurerm_storage_account.storageaccount.primary_blob_endpoint
}
output "endpoint2" {
  value = azurerm_storage_account.storageaccount.secondary_blob_endpoint
}
