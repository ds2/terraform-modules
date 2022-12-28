variable "name" {
  type        = string
  description = "Name of the role"
}

variable "description" {
  type        = string
  description = "the description of the role"
}

variable "actions" {
  type    = set(string)
  default = []
}
variable "dataActions" {
  type    = set(string)
  default = []
}
variable "notActions" {
  type    = set(string)
  default = []
}

variable "scopes" {
  type    = list(string)
  default = []
}
