variable "name" {
  type = string
}

variable "groupId" {
  type    = string
  default = null
}

variable "description" {
  type    = string
  default = "my new project"
}

variable "tags" {
  type    = set(string)
  default = null
}

variable "wikiEnabled" {
  type    = bool
  default = false
}

variable "lfsEnabled" {
  type    = bool
  default = true
}

variable "snippetsEnabled" {
  type    = bool
  default = true
}

variable "pipelinesEnabled" {
  type    = bool
  default = true
}

variable "dockerRegistryEnabled" {
  type    = bool
  default = false
}

variable "approvalsBeforeMerge" {
  type    = number
  default = 0
}

variable "mergeRequestsEnabled" {
  type    = bool
  default = true
}

variable "issuesEnabled" {
  type    = bool
  default = false
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "defaultBranch" {
  type    = string
  default = "master"
}

variable "jiraUrl" {
  type    = string
  default = null
}

variable "jiraUser" {
  type    = string
  default = null
}

variable "jiraPw" {
  type    = string
  default = null
}

variable "jiraProjectKey" {
  type    = string
  default = null
}

variable "releaseTagPattern" {
  type    = string
  default = "v*"
}

variable "sharedRunnersEnabled" {
  type    = bool
  default = true
}
