provider "github" {
  token = var.gh_token
  owner = var.gh_org
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
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
}

# Create a new, red colored label
resource "github_issue_labels" "test_repo" {
  repository = module.repo1.name

  label {
    name  = "Urgent"
    color = "FF0000"
  }

  label {
    name  = "Critical"
    color = "FF0000"
  }
}
