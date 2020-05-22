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

variable "protect_master_inclAdmins" {
  type    = bool
  default = false
}

variable "protect_master_admins" {
  type    = set(string)
  default = []
}

variable "protect_master_teams" {
  type    = set(string)
  default = []
}

variable "protect_master_apps" {
  type    = set(string)
  default = []
}

variable "masterProtection" {
  type = object({
    signed                 = bool
    enforceAdmins          = bool
    restrictToUsers        = set(string)
    restrictToTeamSlugs    = set(string)
    restrictToApps         = set(string)
    statusCheckContexts    = set(string)
    prCodeOwnerReview      = bool
    prApprovalCount        = number
    prDismissFromUsers     = set(string)
    prDismissFromTeamSlugs = set(string)
    ciSuccessful           = bool
    }
  )
  default = {
    signed                 = false
    enforceAdmins          = false
    ciSuccessful           = false
    restrictToUsers        = []
    restrictToTeamSlugs    = []
    restrictToApps         = []
    statusCheckContexts    = ["ci/travis"]
    prCodeOwnerReview      = true
    prApprovalCount        = 1
    prDismissFromUsers     = []
    prDismissFromTeamSlugs = []
  }

}


variable "developProtection" {
  type = object({
    signed                 = bool
    enforceAdmins          = bool
    restrictToUsers        = set(string)
    restrictToTeamSlugs    = set(string)
    restrictToApps         = set(string)
    statusCheckContexts    = set(string)
    prCodeOwnerReview      = bool
    prApprovalCount        = number
    prDismissFromUsers     = set(string)
    prDismissFromTeamSlugs = set(string)
    ciSuccessful           = bool
    }
  )
  default = {
    signed                 = false
    enforceAdmins          = false
    ciSuccessful           = false
    restrictToUsers        = []
    restrictToTeamSlugs    = []
    restrictToApps         = []
    statusCheckContexts    = ["ci/travis"]
    prCodeOwnerReview      = true
    prApprovalCount        = 1
    prDismissFromUsers     = []
    prDismissFromTeamSlugs = []
  }

}
