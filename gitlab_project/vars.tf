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

variable "pipelinesVisibility" {
  type        = string
  description = "Set to private or public!"
  default     = "private"
}

variable "dockerRegistryEnabled" {
  type    = bool
  default = false
}

variable "dockerRegistryVisibility" {
  type        = string
  description = "Set to private or public"
  default     = "private"
}

variable "approvalsBeforeMerge" {
  type    = number
  default = 1
}

variable "mergeRequestsEnabled" {
  type    = bool
  default = true
}

variable "developers" {
  type        = set(string)
  default     = []
  description = "the email addresses of the developers for this project"
}

variable "reporters" {
  type        = set(string)
  default     = []
  description = "the email addresses of the reporters for this project"
}

variable "guests" {
  type        = set(string)
  default     = []
  description = "the email addresses of the guests for this project"
}

variable "issuesEnabled" {
  type    = bool
  default = true
}

variable "visibility" {
  type    = string
  default = "private"
}

variable "pagesVisibility" {
  type    = string
  default = "private"
}

variable "defaultBranch" {
  type    = string
  default = "main"
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
  type      = string
  default   = null
  sensitive = true
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
  default = false
  # we have a kube cluster for this ;)
}

variable "initialize" {
  type    = bool
  default = false
}

variable "packagesEnabled" {
  type    = bool
  default = false
}

variable "mainBranchName" {
  type    = string
  default = "main"
}

variable "developBranchName" {
  type    = string
  default = "develop"
}

variable "allowDevelopForcePush" {
  type    = bool
  default = false
}

variable "allowMainForcePush" {
  type    = bool
  default = false
}

variable "squash" {
  type    = string
  default = "default_on"
}

variable "resetApprovalsOnPush" {
  type    = bool
  default = null
}

variable "prStrategy" {
  type    = string
  default = "ff"
}

variable "keepLatestArtifact" {
  type        = bool
  description = "Whether to keep all artifacts from a CI job, or to use their configured lifetime instead."
  default     = null
}
