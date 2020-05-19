provider "gitlab" {
    token = var.gitlab_token
    version = ">=2.6"
}

terraform {
  required_version = ">= 0.12"
}

module "gitlab_test" {
  source = "../../gitlab_project"
  name   = "infra001-test-bucket-20200212"
}
