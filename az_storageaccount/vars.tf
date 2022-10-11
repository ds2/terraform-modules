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

variable "blobs" {
  type    = set(string)
  default = []
}

variable "privates" {
  type    = set(string)
  default = []
}
