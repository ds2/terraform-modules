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

variable "rsaBits" {
  type    = number
  default = 4096
}

variable "rsaPublicKey" {
  type        = string
  description = "A predefined ssh rsa public key"
  default     = ""
}
