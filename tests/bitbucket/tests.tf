provider "bitbucket" {
  username = var.username
  password = var.userpw
  version  = ">= 1.2"
}
provider "template" {
  version = ">= 2.1"
}

terraform {
  required_version = ">= 0.12"
}

data "bitbucket_user" "lexxy23" {
  username = "{f5aee987-bd9b-4da0-beab-ba903286e189}"
}

module "testproject" {
  source    = "../../bitbucket_repository"
  id        = "infra-test-202003"
  name      = "My Infra Test Project"
  ownerName = var.username
  reviewers = [var.username]
  # reviewers = [data.bitbucket_user.lexxy23.uuid]
}
