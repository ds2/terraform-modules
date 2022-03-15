/**
 * # Azure Resourcegroup
 * 
 * to easily setup an azure resourcegroup via terraform.
*/

locals {
  my_tags = {
    Name        = var.id
    Terraformed = true
  }
  merged_maps = merge(local.my_tags, var.additionalTags)
  # dist_keys   = distinct([for t in local.merged_maps : t["key"]])
}

resource "azurerm_resource_group" "resgrp" {
  name     = var.id
  location = var.location
  tags     = local.merged_maps
}
