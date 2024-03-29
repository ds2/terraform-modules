provider "github" {
  token = var.gh_token
  owner = var.gh_org
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

module "team1" {
  source      = "../../github_team"
  name        = "infra001-test-team1_20220304"
  description = "a test team"
  members     = ["ds2ci"]
}

module "repo1" {
  source              = "../../github_project"
  name                = "infra001-test-bucket-20220304"
  topics              = ["test", "maven", "java"]
  initialize          = true
  isPrivate           = false
  projectLicenseId    = "agpl-3.0"
  gitignoreTemplateId = "Gradle"
  admins              = ["lexxy23", "ds2ci"]
  teamSlugs           = [module.team1.slug]
  allowUpdateBranch   = false
  hasIssues           = true
  labels = {
    "urgent"   = ["ff0000", "urgent tasks to do"]
    "critical" = ["ff0000"]
  }
}

module "repo1_main" {
  source             = "../../github_protect_branch"
  pattern            = "main"
  repository_node_id = module.repo1.node_id
}
