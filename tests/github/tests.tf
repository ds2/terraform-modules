provider "github" {
  token        = var.gh_token
  version      = "~> 2.8"
  organization = var.gh_org
}

terraform {
  required_version = ">= 0.12"
}

module "repo1" {
  source              = "../../github_project"
  name                = "infra001-test-bucket-20200520"
  topics              = ["test", "maven", "java"]
  initialize          = true
  isPrivate           = false
  projectLicenseId    = "agpl-3.0"
  gitignoreTemplateId = "Gradle"
}
