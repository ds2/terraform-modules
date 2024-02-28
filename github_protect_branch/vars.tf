variable "enabled" {
  type    = bool
  default = true
}
variable "repository_node_id" {
  type = string
}

variable "pattern" {
  type = string
}

variable "enforceAdmins" {
  type    = bool
  default = true
}

variable "allowForcePush" {
  type    = bool
  default = false
}

variable "push_node_ids" {
  type    = list(string)
  default = []
}

variable "dismissal_node_ids" {
  type    = list(string)
  default = []
}
variable "required_approving_review_count" {
  type    = number
  default = 0
}
variable "prBypasserNodeIds" {
  type    = list(string)
  default = []
}
variable "require_last_push_approval" {
  type    = bool
  default = true
}

variable "require_code_owner_reviews" {
  type    = bool
  default = true
}
variable "restrict_dismissals" {
  type    = bool
  default = true
}

variable "requireStrictStatusChecks" {
  type    = bool
  default = false
}
variable "status_checks_contexts" {
  type    = list(string)
  default = []
}
