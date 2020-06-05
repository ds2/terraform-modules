variable "owner" {
  type = string
}

variable "repoName" {
  type = string
}

variable "repoId" {
  type = string
}

variable "descr" {
  type    = string
  default = null
}

variable "isPrivate" {
  type    = bool
  default = true
}

variable "language" {
  type    = string
  default = "java"
}

variable "hasIssues" {
  type    = bool
  default = false
}

variable "hasWiki" {
  type    = bool
  default = false
}

variable "hasPipelines" {
  type    = bool
  default = true
}

variable "forkPolicy" {
  type    = string
  default = "no_forks"
}

variable "reviewers" {
  type    = set(string)
  default = null
}
