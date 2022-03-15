/**
 * # Azure Resourcegroup
 * 
 * to easily setup an azure resourcegroup via terraform.
*/
resource "azurerm_resource_group" "resgrp" {
  name     = var.id
  location = var.location
  tags = {
    Name        = var.id
    Terraformed = true
  }
}
