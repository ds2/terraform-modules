provider "github" {
  token        = var.gh_token
  organization = var.gh_org
}

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 2.9.2"
    }
  }
}

module "team1" {
  source      = "../../github_team"
  name        = "infra001-test-team1_20210111"
  description = "a test team"
  members     = ["ds2ci"]
}

# module "repo1" {
#   source              = "../../github_project"
#   name                = "infra001-test-bucket-20200520"
#   topics              = ["test", "maven", "java"]
#   initialize          = true
#   isPrivate           = false
#   projectLicenseId    = "agpl-3.0"
#   gitignoreTemplateId = "Gradle"
# }
