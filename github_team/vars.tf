variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "isSecret" {
  type    = bool
  default = true
}

variable "parentTeamId" {
  type    = string
  default = null
}

variable "members" {
  type    = set(string)
  default = []
}

variable "maintainers" {
  type    = set(string)
  default = []
}