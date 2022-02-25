terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.6.0"
    }
  }
  required_version = "~> 1.1.0"
}

provider "gitlab" {
  token = var.gitlab_token
}

module "gitlab_test" {
  source = "../../gitlab_project"
  name   = "infra001-test-bucket-20201201"
}
