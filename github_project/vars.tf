variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "hasProjects" {
  type    = bool
  default = false
}
variable "hasIssues" {
  type    = bool
  default = false
}
variable "hasWiki" {
  type    = bool
  default = false
}
variable "hasDownloads" {
  type    = bool
  default = false
}

variable "homepage" {
  type    = string
  default = null
}
variable "defaultBranch" {
  type    = string
  default = "master"
}

variable "isPrivate" {
  type    = bool
  default = true
}

variable "admins" {
  type    = set(string)
  default = []
}

variable "teamIds" {
  type    = set(string)
  default = []
}

variable "topics" {
  type    = set(string)
  default = null
}

variable "initialize" {
  type    = bool
  default = null
}

variable "projectLicenseId" {
  description = "See https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  type        = string
  default     = null
}

variable "gitignoreTemplateId" {
  description = "See https://github.com/github/gitignore"
  type        = string
  default     = null
}
