variable "path" {
  type = string
}

variable "name" {
  type    = string
  default = "My group name"
}

variable "description" {
  type    = string
  default = "Another group"
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "parent_group_id" {
  type    = number
  default = null
}

variable "require2FA" {
  type    = bool
  default = true
}

variable "allowEmails" {
  type    = bool
  default = true
}

variable "autoDevOps" {
  type    = bool
  default = false
}

variable "preventOutsideGrpForking" {
  type    = bool
  default = true
}
