resource "azurerm_resource_group" "resgrp" {
  name     = var.id
  location = var.location
  tags = {
    Name        = var.id
    Terraformed = true
  }
}
