variable "resourceGroupName" {
  type = string
}

variable "storageAccountName" {
  type = string
}

variable "access_tier" {
  type    = string
  default = "Cool"
}

variable "allowPublicItems" {
  type    = bool
  default = false
}

variable "replicationStrategy" {
  type    = string
  default = "LRS"
}

variable "additionalTags" {
  type    = map(string)
  default = {}
}
