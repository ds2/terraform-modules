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

variable "usePrefix" {
  type    = bool
  default = true
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
  type        = string
  description = "the usage type. If unsure, use SYMMETRIC_DEFAULT for using in RDS encryption"
  default     = "RSA_4096"
}

variable "adminArns" {
  type    = set(string)
  default = []
}
