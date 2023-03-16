data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tags = merge({
    Terraformed = true
    Name        = var.name
  }, var.additionalTags)
  useExistingRsaKey = length(var.rsaPublicKey) > 0
}

resource "tls_private_key" "ssh" {
  count     = local.useExistingRsaKey ? 0 : 1
  algorithm = "RSA" # Azure only allows RSA keys, sry
  rsa_bits  = var.rsaBits >= 2048 ? var.rsaBits : 4096
}

resource "azurerm_ssh_public_key" "key" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.resgrp.name
  location            = data.azurerm_resource_group.resgrp.location
  public_key          = local.useExistingRsaKey ? var.rsaPublicKey : chomp(tls_private_key.ssh[0].public_key_openssh)
  tags                = local.tags
}
