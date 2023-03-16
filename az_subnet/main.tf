data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tags = merge({
    Terraformed = true
    Name        = var.name
  }, var.additionalTags)
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtualNetworkName
  resource_group_name = data.azurerm_resource_group.resgrp.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.name
  resource_group_name  = data.azurerm_resource_group.resgrp.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.cidrs
}
