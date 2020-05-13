variable "name" {
  type = string
}

variable "descr" {
  type    = string
  default = "my kms key"
}

variable "keyRotation" {
  type    = bool
  default = true
}

variable "deletionDays" {
  type    = number
  default = 7
}

variable "aliasName" {
  type    = string
  default = "my-test-key"
}
variable "aliasPrefix" {
  type    = string
  default = null
}

variable "enabled" {
  type    = bool
  default = true
}

variable "keyUsage" {
  type    = string
  default = "ENCRYPT_DECRYPT"
}

variable "keySpec" {
  type    = string
  default = "RSA_4096"
}
