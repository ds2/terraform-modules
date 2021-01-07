resource "azurerm_resource_group" "resgrp" {
  name     = var.name
  location = var.location
  tags = {
    Name        = var.name
    Terraformed = true
  }
}
