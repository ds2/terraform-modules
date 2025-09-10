/**
 * # gitlab_project
 *
 * To create a gitlab project.
 */

resource "gitlab_project" "project" {
  name                                             = var.name
  namespace_id                                     = var.groupId
  description                                      = var.description
  topics                                           = var.tags
  wiki_enabled                                     = var.wikiEnabled
  lfs_enabled                                      = var.lfsEnabled
  issues_enabled                                   = var.issuesEnabled
  merge_requests_enabled                           = var.mergeRequestsEnabled
  merge_method                                     = var.prStrategy
  keep_latest_artifact                             = var.keepLatestArtifact
  container_registry_access_level                  = var.dockerRegistryEnabled ? var.dockerRegistryVisibility : "disabled"
  packages_enabled                                 = var.packagesEnabled
  builds_access_level                              = var.pipelinesEnabled ? var.pipelinesVisibility : "disabled"
  snippets_enabled                                 = var.snippetsEnabled
  visibility_level                                 = var.visibility
  pages_access_level                               = var.pagesVisibility
  default_branch                                   = var.defaultBranch
  shared_runners_enabled                           = var.sharedRunnersEnabled
  request_access_enabled                           = false
  initialize_with_readme                           = var.initialize
  only_allow_merge_if_pipeline_succeeds            = true
  only_allow_merge_if_all_discussions_are_resolved = true
  allow_merge_on_skipped_pipeline                  = false
  remove_source_branch_after_merge                 = true
  squash_option                                    = var.squash
  ci_separated_caches                              = true
}

resource "gitlab_branch_protection" "master_protect" {
  allow_force_push   = var.allowMainForcePush
  project            = gitlab_project.project.id
  branch             = var.mainBranchName
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}

resource "gitlab_branch_protection" "develop_protect" {
  project            = gitlab_project.project.id
  branch             = var.developBranchName
  allow_force_push   = var.allowDevelopForcePush
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}

resource "gitlab_branch_protection" "release_protect" {
  project            = gitlab_project.project.id
  branch             = "release/*"
  push_access_level  = "maintainer"
  merge_access_level = "developer"
}

resource "gitlab_integration_jira" "jira" {
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
  project      = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "developer"
}

resource "gitlab_project_membership" "guestMembers" {
  for_each     = data.gitlab_user.guests
  project      = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "guest"
}

resource "gitlab_project_membership" "reportMembers" {
  for_each     = data.gitlab_user.reporters
  project      = gitlab_project.project.id
  user_id      = each.value.user_id
  access_level = "reporter"
}

resource "gitlab_project_level_mr_approvals" "mrapprovals" {
  project                                        = gitlab_project.project.id
  reset_approvals_on_push                        = var.resetApprovalsOnPush
  disable_overriding_approvers_per_merge_request = false
  merge_requests_author_approval                 = false
  merge_requests_disable_committers_approval     = true
  lifecycle {
    ignore_changes = [reset_approvals_on_push # because closed source repos do not support it on GITLAB cloud.
    ]
  }
}

locals {
  developer_user_ids = toset([for k, v in data.gitlab_user.developers : v.user_id])
  dui                = [for user in data.gitlab_user.developers : user.id]
}

resource "gitlab_project_approval_rule" "approverule1" {
  project            = gitlab_project.project.id
  name               = "Users allowed to approve a MR"
  approvals_required = 1
  user_ids           = local.dui
  rule_type          = "regular"
  # group_ids          = [51]
}
