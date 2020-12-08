terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.3.0"
    }
  }
  required_version = ">= 0.13"
}

provider "gitlab" {
  token = var.gitlab_token
}

module "gitlab_test" {
  source = "../../gitlab_project"
  name   = "infra001-test-bucket-20201201"
}
