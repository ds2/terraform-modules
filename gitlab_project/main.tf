resource "gitlab_project" "project" {
  name                                             = var.name
  namespace_id                                     = var.groupId
  description                                      = var.description
  tags                                             = var.tags
  wiki_enabled                                     = var.wikiEnabled
  lfs_enabled                                      = var.lfsEnabled
  issues_enabled                                   = var.issuesEnabled
  merge_requests_enabled                           = var.mergeRequestsEnabled
  approvals_before_merge                           = var.approvalsBeforeMerge
  container_registry_enabled                       = var.dockerRegistryEnabled
  packages_enabled                                 = null
  pipelines_enabled                                = var.pipelinesEnabled
  snippets_enabled                                 = var.snippetsEnabled
  visibility_level                                 = var.visibility
  default_branch                                   = var.defaultBranch
  shared_runners_enabled                           = var.sharedRunnersEnabled
  request_access_enabled                           = false
  initialize_with_readme                           = var.initialize
  only_allow_merge_if_pipeline_succeeds            = true
  only_allow_merge_if_all_discussions_are_resolved = true
  remove_source_branch_after_merge                 = true
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

resource "gitlab_service_jira" "jira" {
  for_each    = var.jiraUrl != null ? toset([""]) : []
  project     = gitlab_project.project.id
  project_key = var.jiraProjectKey
  url         = var.jiraUrl
  username    = var.jiraUser
  password    = var.jiraPw
}

resource "gitlab_tag_protection" "protect_tags" {
  project             = gitlab_project.project.id
  tag                 = var.releaseTagPattern
  create_access_level = "maintainer"
}

data "gitlab_user" "guests" {
  for_each = var.guests
  email    = each.key
}

data "gitlab_user" "reporters" {
  for_each = var.reporters
  email    = each.key
}

data "gitlab_user" "developers" {
  for_each = var.developers
  email    = each.key
}

resource "gitlab_project_membership" "devMembers" {
  for_each     = data.gitlab_user.developers
  project_id   = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "developer"
}

resource "gitlab_project_membership" "guestMembers" {
  for_each     = data.gitlab_user.guests
  project_id   = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "guest"
}

resource "gitlab_project_membership" "reportMembers" {
  for_each     = data.gitlab_user.reporters
  project_id   = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "reporter"
}
