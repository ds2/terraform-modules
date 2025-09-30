variable "path" {
  type = string
}

variable "name" {
  type        = string
  description = "The name of the group"
  default     = "My group name"
}

variable "description" {
  type        = string
  description = "The description of the group, a sub title"
  default     = "Another group"
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "parent_group_id" {
  type        = number
  description = "In case this group is a sub group, this number is the id of the parent group"
  default     = null
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
