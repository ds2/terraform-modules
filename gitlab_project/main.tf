resource "gitlab_project" "project" {
  name                       = var.name
  namespace_id               = var.groupId
  description                = var.description
  tags                       = var.tags
  wiki_enabled               = var.wikiEnabled
  lfs_enabled                = var.lfsEnabled
  issues_enabled             = var.issuesEnabled
  merge_requests_enabled     = var.mergeRequestsEnabled
  approvals_before_merge     = var.approvalsBeforeMerge
  container_registry_enabled = var.dockerRegistryEnabled
  pipelines_enabled          = var.pipelinesEnabled
  visibility_level           = var.visibility
  default_branch             = var.defaultBranch
}

resource "gitlab_branch_protection" "master_protect" {
  project            = gitlab_project.project.id
  branch             = "master"
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}

resource "gitlab_branch_protection" "develop_protect" {
  project            = gitlab_project.project.id
  branch             = "develop"
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}

resource "gitlab_branch_protection" "release_protect" {
  project            = gitlab_project.project.id
  branch             = "release/*"
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}
