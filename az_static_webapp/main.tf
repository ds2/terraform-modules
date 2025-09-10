data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tagMap = merge({
    terraformed = true
    name        = var.name
  }, var.additionalTags)
}

resource "azurerm_static_site" "site" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.resgrp.name
  location            = var.location
  sku_tier            = var.skuTier
  sku_size            = var.skuSize
  tags                = local.tagMap
}
