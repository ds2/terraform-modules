data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tagMap = merge({
    terraformed = true
    name        = var.storageAccountName
  }, var.additionalTags)
}

resource "azurerm_storage_account" "storageaccount" {
  name                      = var.storageAccountName
  resource_group_name       = data.azurerm_resource_group.resgrp.name
  location                  = data.azurerm_resource_group.resgrp.location
  account_tier              = "Standard"
  account_replication_type  = var.replicationStrategy
  access_tier               = var.access_tier
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  # allow_blob_public_access  = var.allowPublicItems
  shared_access_key_enabled         = true
  nfsv3_enabled                     = false
  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled       = true
    change_feed_enabled      = true
    last_access_time_enabled = true

    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  queue_properties {
    logging {
      delete                = true
      retention_policy_days = 30
      read                  = false
      version               = "1.0"
      write                 = true
    }
  }
  # static_website {
  #   index_document     = "index.html"
  #   error_404_document = "/404.html"
  # }

  tags = local.tagMap
}

# resource "azurerm_storage_container" "container1" {
#   name                  = "snapshots"
#   storage_account_name  = azurerm_storage_account.storageaccount.name
#   container_access_type = "private"
# }
# resource "azurerm_storage_container" "container2" {
#   name                  = "releases"
#   storage_account_name  = azurerm_storage_account.storageaccount.name
#   container_access_type = "private"
# }
