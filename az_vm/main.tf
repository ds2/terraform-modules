data "azurerm_resource_group" "resgrp" {
  name = var.resourceGroupName
}

locals {
  tags = merge({
    Terraformed = true
    Name        = var.name
  }, var.additionalTags)
  enableShutdown = var.dailyShutdownTime != null && try(length(var.dailyShutdownTime), 0) > 0
  adminPwStr     = var.adminpw == null ? "" : var.adminpw
  haspw          = length(local.adminPwStr) > 0
}

data "azurerm_ssh_public_key" "pubkey" {
  for_each            = var.sshPubKeyNames
  name                = each.key
  resource_group_name = data.azurerm_resource_group.resgrp.name
}

data "azurerm_virtual_network" "vnet1" {
  name                = var.virtualNetworkName
  resource_group_name = data.azurerm_resource_group.resgrp.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnetName
  resource_group_name  = data.azurerm_resource_group.resgrp.name
  virtual_network_name = data.azurerm_virtual_network.vnet1.name
}

resource "azurerm_network_interface" "if01" {
  name                    = var.name
  tags                    = local.tags
  resource_group_name     = data.azurerm_resource_group.resgrp.name
  location                = data.azurerm_resource_group.resgrp.location
  internal_dns_name_label = var.name
  ip_configuration {
    # you must have IPv4 at least ..
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = var.subnetUseIpv6 ? true : null # ipv4 is always primary; you cannot enable ipv6 as primary for now
  }
  dynamic "ip_configuration" {
    for_each = var.subnetUseIpv6 ? [1] : []
    content {
      name                          = "internal-ipv6"
      subnet_id                     = data.azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
      private_ip_address_version    = "IPv6"
    }
  }
}

resource "azurerm_linux_virtual_machine" "machine" {
  name                            = var.name
  resource_group_name             = data.azurerm_resource_group.resgrp.name
  location                        = data.azurerm_resource_group.resgrp.location
  size                            = var.vmSize
  admin_username                  = var.adminuser
  admin_password                  = var.adminpw
  disable_password_authentication = !local.haspw
  encryption_at_host_enabled      = var.encryptionAtHost

  network_interface_ids = [
    azurerm_network_interface.if01.id,
  ]

  dynamic "admin_ssh_key" {
    for_each = data.azurerm_ssh_public_key.pubkey
    content {
      username   = var.adminuser
      public_key = admin_ssh_key.value.public_key
    }
  }
  dynamic "admin_ssh_key" {
    for_each = var.sshPubKeys
    content {
      username   = var.adminuser
      public_key = admin_ssh_key.value
    }
  }

  os_disk {
    name                      = var.osDiskName
    caching                   = var.osDiskEnableWriteAccelerator ? "None" : "ReadWrite"
    storage_account_type      = var.osDiskStorageType
    disk_size_gb              = var.osDiskSize
    write_accelerator_enabled = var.osDiskEnableWriteAccelerator
  }

  source_image_reference {
    publisher = var.osPublisher
    offer     = var.osOffer
    sku       = var.osVersion
    version   = var.osImageVersion
  }
  tags = local.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id    = azurerm_linux_virtual_machine.machine.id
  location              = data.azurerm_resource_group.resgrp.location
  enabled               = local.enableShutdown
  daily_recurrence_time = var.dailyShutdownTime
  timezone              = var.dailyShutdownTimezoneName

  notification_settings {
    enabled = local.enableShutdown && (
      try(length(var.dailyShutdownEmail), 0) > 0 || try(length(var.dailyShutdownWebhookUrl), 0) > 0
    )
    time_in_minutes = 15
    webhook_url     = var.dailyShutdownWebhookUrl
    email           = var.dailyShutdownEmail
  }
  tags = local.tags
}

resource "azurerm_network_security_group" "sg" {
  name                = "${var.name}-nsg"
  resource_group_name = data.azurerm_resource_group.resgrp.name
  location            = data.azurerm_resource_group.resgrp.location

  tags = local.tags
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-inbound-ssh"
  resource_group_name         = data.azurerm_resource_group.resgrp.name
  network_security_group_name = azurerm_network_security_group.sg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.sshPort
  source_address_prefix       = "*" # this should match our internal LAN CIDR, or simply use VirtualNetwork
  destination_address_prefix  = "*" # maybe use VirtualNetwork here
}

resource "azurerm_network_interface_security_group_association" "sg2if" {
  network_interface_id      = azurerm_network_interface.if01.id
  network_security_group_id = azurerm_network_security_group.sg.id
}
