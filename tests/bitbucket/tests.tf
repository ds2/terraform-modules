terraform {
  required_providers {
    bitbucket = {
      source  = "terraform-providers/bitbucket"
      version = ">= 1.2"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.1"
    }
  }
  required_version = ">= 0.13"
}

provider "bitbucket" {
  username = var.username
  password = var.userpw

}
provider "template" {
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
