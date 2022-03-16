variable "resourceGroupName" {
  type = string
}

variable "name" {
  type = string
}
variable "additionalTags" {
  type    = map(string)
  default = {}
}

variable "rsaPublicKey" {
  type = string
}
