data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tags = merge({
    Terraformed = true
    Name        = var.name
  }, var.additionalTags)
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.name
  address_space       = var.cidrs
  location            = data.azurerm_resource_group.resgrp.location
  resource_group_name = data.azurerm_resource_group.resgrp.name
  tags                = local.tags
}
