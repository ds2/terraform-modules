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

variable "osDiskSize" {
  type    = number
  default = null
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
  type = string
}

variable "subnetName" {
  type = string
}
variable "subnetUseIpv6" {
  type    = bool
  default = true
}

variable "sshPort" {
  type    = number
  default = 22
}

variable "encryptionAtHost" {
  type    = bool
  default = true
}

variable "dailyShutdownTime" {
  type        = string
  default     = null
  description = "A cron-like value, for example 2100 for 9pm"
}

variable "dailyShutdownWebhookUrl" {
  type    = string
  default = null
}
variable "dailyShutdownEmail" {
  type    = string
  default = null
}
variable "dailyShutdownTimezoneName" {
  type    = string
  default = "W. Europe Standard Time"

}
