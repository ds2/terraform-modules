terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.0"
    }
  }
  required_version = "~> 1.0"
}

provider "gitlab" {
  token = var.gitlab_token
}

module "gitlab_test" {
  source = "../../gitlab_project"
  name   = "infra001-test-bucket-20230524"
}
