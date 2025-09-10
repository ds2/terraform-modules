terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 17.0"
    }
  }
  required_version = "~> 1.0"
}

provider "gitlab" {
  token = var.gitlab_token
}

data "gitlab_current_user" "curruser" {}

# you must create this path via gitlab.com before!!
module "glgrp01" {
  source = "../../gitlab_group"
  path   = "ds2-tm-test-grp-20230530"
}
# after creation, import the id of the group into the module: execute.sh -i "module.glgrp01.gitlab_group.grp 12345"

module "gitlab_test" {
  source  = "../../gitlab_project"
  name    = "infra001-test-bucket-20230524"
  groupId = module.glgrp01.id
}
