terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">=17.0"
    }
  }
  required_version = ">= 1.0"
}
