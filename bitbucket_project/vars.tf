variable "workspaceId" {
  type        = string
  description = "the workspace id aka team"
}

variable "name" {
  type = string
}

variable "id" {
  type = string
}

variable "descr" {
  type    = string
  default = "my test project"
}

variable "isPrivate" {
  type    = bool
  default = true
}
