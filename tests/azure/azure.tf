terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.0"
    }
  }
  required_version = "~> 1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
}

data "azurerm_subscription" "primary" {
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
  name              = "mein_key_1"
  resourceGroupName = module.resgrp.name
  rsaPublicKey      = chomp(tls_private_key.ssh.public_key_openssh)
}

# Create a virtual network within the resource group
# resource "azurerm_virtual_network" "vnet1" {
#   name                = "tm-test-nw1"
#   resource_group_name = module.resgrp.name
#   location            = module.resgrp.location
#   address_space       = ["10.185.0.0/16"]
# }

module "blob1" {
  source             = "../../az_storageaccount"
  storageAccountName = "ds2testacc1"
  resourceGroupName  = module.resgrp.name
}

module "principal" {
  source      = "../../az_serviceprincipal"
  description = "test principal 1"
  appName     = "Test App 1"
}

module "role1" {
  source      = "../../az_role"
  name        = "Blob Container Role"
  description = "A role to assign container access to service principals"
  actions = [
    "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
    "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/write",
    "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action"
  ]
  dataActions = [
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
    "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
  ]
  scopes = [
    module.blob1.id
  ]
}

resource "random_uuid" "test" {
}

resource "azurerm_role_assignment" "roleassign1" {
  name               = random_uuid.test.result
  scope              = module.blob1.id
  role_definition_id = module.role1.resourceId
  principal_id       = module.principal.object_id
  description        = "test assign 1"
}
