terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }
  required_version = "~> 1.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.az_subscription_id
  tenant_id       = var.azTenantId
}

# data "azurerm_subscription" "primary" {
# }

module "resgrp" {
  source   = "../../az_resgrp"
  id       = "tm-test-2022.03.09"
  location = var.location
  additionalTags = {
    "createdBy" = "me"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA" # Azure only allows RSA keys, sry
  rsa_bits  = 4096
}

module "pubkey" {
  source            = "../../az_ssh_pubkey"
  name              = "mein_key_1"
  resourceGroupName = module.resgrp.name
  rsaPublicKey      = chomp(tls_private_key.ssh.public_key_openssh)
  additionalTags = {
    "createdBy" = "aqcae"
  }
}
module "pubkey2" {
  source            = "../../az_ssh_key"
  name              = "mein_key_2"
  resourceGroupName = module.resgrp.name
  additionalTags = {
    "createdBy" = "aqcae"
  }
}
# module "pubkey3" {
#   source            = "../../az_ssh_key"
#   name              = "mein_key_3"
#   resourceGroupName = module.resgrp.name
#   rsaPublicKey      = file("~/.ssh/dedalus_rsa.pub")
#   additionalTags = {
#     "createdBy" = "aqcae"
#   }
# }

module "vnet1" {
  source            = "../../az_virtualnetwork"
  name              = "tm-test-vnet01"
  resourceGroupName = module.resgrp.name
  # see https://www.unique-local-ipv6.com/
  cidrs = ["10.186.0.0/16", "fd5b:7944:9952::/48"]
}

module "blob1" {
  source             = "../../az_storageaccount"
  storageAccountName = "ds2testacc1"
  resourceGroupName  = module.resgrp.name
}

module "principal" {
  source      = "../../az_serviceprincipal"
  description = "test principal 1"
  name        = "Test App 1"
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

# resource "random_uuid" "test" {
# }

# resource "azurerm_role_assignment" "roleassign1" {
#   name               = random_uuid.test.result
#   scope              = module.blob1.id
#   role_definition_id = module.role1.resourceId
#   principal_id       = module.principal.object_id
#   description        = "test assign 1"
# }

module "roleassign1" {
  source            = "../../az_role_assign"
  scopeId           = module.blob1.id
  roleResourceId    = module.role1.resourceId
  principalObjectId = module.principal.object_id
  description       = "test assign 2"
}

module "subnet01" {
  source             = "../../az_subnet"
  name               = "internal-snet01"
  resourceGroupName  = module.resgrp.name
  virtualNetworkName = module.vnet1.name
  cidrs              = ["10.186.2.0/24", "fd5b:7944:9952::/64"]
}

# module "vm01" {
#   source             = "../../az_vm"
#   name               = "dirktest01"
#   resourceGroupName  = module.resgrp.name
#   sshPubKeyNames     = [module.pubkey2.name]
#   subnetName         = module.subnet01.name
#   virtualNetworkName = module.vnet1.name
#   encryptionAtHost   = false
#   dailyShutdownTime  = "2109"
# }

module "web01" {
  source            = "../../az_static_webapp"
  name              = "az-ws-test-01"
  resourceGroupName = module.resgrp.name
}
