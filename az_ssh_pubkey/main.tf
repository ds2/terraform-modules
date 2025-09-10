data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tags = merge({
    Terraformed = true
    Name        = var.name
  }, var.additionalTags)
}

resource "azurerm_ssh_public_key" "key" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.resgrp.name
  location            = data.azurerm_resource_group.resgrp.location
  public_key          = var.rsaPublicKey
  tags                = local.tags
}
