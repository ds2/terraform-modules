variable "ownerName" {
  type        = string
  description = "the username who will own this repository"
}

variable "name" {
  type = string
}

variable "mainBranchName" {
  type    = string
  default = "main"
}

variable "id" {
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
  type        = set(string)
  default     = null
  description = "The usernames to add as reviewers (NOT UUID!!)"
}

variable "projectId" {
  type        = string
  default     = null
  description = "the project key. If set, the owner must be the project owner!!"
}
