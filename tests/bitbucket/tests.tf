terraform {
  required_providers {
    bitbucket = {
      source  = "terraform-providers/bitbucket"
      version = ">= 1.2"
    }
  }
  required_version = ">= 0.13"
}

provider "bitbucket" {
  username = var.username
  password = var.userpw

}

data "bitbucket_user" "lexxy23" {
  username = "{f5aee987-bd9b-4da0-beab-ba903286e189}"
}

module "testproject1" {
  source      = "../../bitbucket_project"
  workspaceId = "ds-2"
  name        = "BB Infra Test"
  id          = "bb_infra_test"
}

module "testrepo" {
  source       = "../../bitbucket_repository"
  id           = "infra-test-202012_1"
  name         = "My Infra Test Project"
  ownerName    = "ds-2"
  reviewers    = [var.username]
  projectId    = module.testproject1.key
  hasPipelines = false
  # reviewers = [data.bitbucket_user.lexxy23.uuid]
}
