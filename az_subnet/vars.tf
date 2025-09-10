variable "name" {
  type = string
}

variable "virtualNetworkName" {
  type = string
}

variable "cidrs" {
  type    = set(string)
  default = ["10.185.0.0/16"]
}
variable "resourceGroupName" {
  type        = string
  description = "the resource group name for this vm"
}
variable "additionalTags" {
  type    = map(string)
  default = {}
}
