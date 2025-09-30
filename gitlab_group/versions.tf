terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">=18.0"
    }
  }
  required_version = ">= 1.0"
}
