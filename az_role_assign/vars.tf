variable "roleResourceId" {
  type        = string
  description = "The resource id of the role"
}

variable "principalObjectId" {
  type        = string
  description = "The principal object id"
}

variable "scopeId" {
  type        = string
  description = "The scope id of the role assignment"
}

variable "description" {
  type        = string
  default     = null
  description = "the description of the assignment"
}
