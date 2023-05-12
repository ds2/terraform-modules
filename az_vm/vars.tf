variable "name" {
  type        = string
  description = "the name of the VM"
}
variable "resourceGroupName" {
  type        = string
  description = "the resource group name for this vm"
}
variable "additionalTags" {
  type    = map(string)
  default = {}
}

variable "adminuser" {
  type        = string
  default     = "azureuser"
  description = "the root user who can ssh into the machine"
}
variable "adminpw" {
  type        = string
  default     = null
  description = "the ssh password to use. PLEASE USE SSH KEY AUTH INSTEAD!!"
}

variable "vmSize" {
  type = string
  # default = "Standard_F2"
  description = "See https://aka.ms/azure-regionservices for info what to select. Also checkout https://azureprice.net/?region=northeurope just in case."
  default     = "Standard_B1ls"
  # validation {
  #   condition     = contains(["Standard_F2", "Standard_D4s_v3"], var.vmSize)
  #   error_message = "this vm size is unknown!"
  # }
}
variable "osDiskName" {
  type    = string
  default = null
}
variable "osDiskSize" {
  type        = number
  description = "the disk size in GB for the OS disk"
  default     = null
}
variable "osDiskStorageType" {
  type        = string
  default     = "Standard_LRS"
  description = "The type of the OS disk. See http://go.microsoft.com/fwlink/?LinkId=2165317 for more info."
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.osDiskStorageType)
    error_message = "unknown disk storage type!"
  }
}
variable "osDiskEnableWriteAccelerator" {
  type    = bool
  default = false
}

# To configure the OS, you may want to use: az vm image list --all --publisher="Canonical" --sku="22_04-lts-gen2" --architecture="x64" >ubuntu_os.json
variable "osPublisher" {
  type    = string
  default = "canonical"
}
variable "osOffer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}
variable "osVersion" {
  type        = string
  description = "this is the SKU version of the OS."
  default     = "22_04-lts-gen2"
}
variable "osImageVersion" {
  type    = string
  default = "22.04.202303090"
}

variable "sshPubKeyNames" {
  type        = set(string)
  description = "the Azure SSH Pubkey names!"
  default     = []
}

variable "sshPubKeys" {
  type        = set(string)
  description = "some local SSH Keys that you have"
  default     = []
}

variable "virtualNetworkName" {
  type        = string
  description = "the name of the vnet where we also have the subnet from (required for lookup of the subnet)"
}

variable "subnetName" {
  type        = string
  description = "the name of the subnet to put the vm in"
}
variable "subnetUseIpv6" {
  type        = bool
  default     = true
  description = "Whether to use IPv6 on the subnet. Default is true ;)"
}

variable "sshPort" {
  type        = number
  default     = 22
  description = "the ssh port we want to use"
}

variable "encryptionAtHost" {
  type        = bool
  default     = true
  description = "I guess this is being used on company subscriptions. For me, it is deactivated and has to be set to false."
}

variable "dailyShutdownTime" {
  type        = string
  default     = null
  description = "A cron-like value, for example 2100 for 9pm"
}

variable "dailyShutdownWebhookUrl" {
  type        = string
  default     = null
  description = "the URL to call before we shut down the VM."
}
variable "dailyShutdownEmail" {
  type        = string
  default     = null
  description = "the email address to use to notify the shutdown of the vm."
}
variable "dailyShutdownTimezoneName" {
  type        = string
  default     = "W. Europe Standard Time"
  description = "the time zone for the shutdown time."
}
