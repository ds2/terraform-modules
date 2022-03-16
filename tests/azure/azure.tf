terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.0"
    }
  }
  required_version = "~> 1.1.0"
}

provider "azurerm" {
  features {}
}

module "resgrp" {
  source   = "../../az_resgrp"
  id       = "tm-test-2022.03.09"
  location = var.location
  additionalTags = {
    "createdBy" = "me"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

module "pubkey" {
  source            = "../../az_ssh_pubkey"
  name              = "Mein Key"
  resourceGroupName = module.resgrp.name
  rsaPublicKey      = chomp(tls_private_key.ssh.public_key_openssh)
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet1" {
  name                = "tm-test-nw1"
  resource_group_name = module.resgrp.name
  location            = module.resgrp.location
  address_space       = ["10.185.0.0/16"]
}
