resource "github_repository" "project" {
  name                   = var.name
  vulnerability_alerts   = var.vulnerabilityAlerts
  archive_on_destroy     = true
  description            = var.description
  homepage_url           = var.homepage
  visibility             = var.isPrivate ? "private" : "public"
  has_projects           = var.hasProjects
  has_issues             = var.hasIssues
  has_wiki               = var.hasWiki
  has_downloads          = var.hasDownloads
  delete_branch_on_merge = var.deleteBranchOnMerge
  topics                 = var.topics
  auto_init              = var.initialize
  allow_rebase_merge     = var.allowRebaseMerge
  allow_squash_merge     = var.allowSquashMerge
  allow_merge_commit     = var.allowMergeCommits
  is_template            = false
  license_template       = var.projectLicenseId
  gitignore_template     = var.gitignoreTemplateId
  archived               = false
}

resource "github_branch_default" "defaultBranch" {
  repository = github_repository.project.name
  branch     = var.defaultBranchName
}

resource "github_repository_collaborator" "admins" {
  for_each   = toset(var.admins)
  repository = github_repository.project.name
  username   = each.key
  permission = "admin"
  depends_on = [github_repository.project]
}

resource "github_team_repository" "team2repo" {
  for_each   = toset(data.github_team.teams[*].id)
  team_id    = each.key
  repository = github_repository.project.name
  permission = "push"
}

resource "github_branch" "branch_develop" {
  count         = length(var.developBranchName) > 0 ? 1 : 0
  repository    = github_repository.project.name
  source_branch = var.defaultBranchName
  branch        = var.developBranchName
}

data "github_users" "admins" {
  usernames = var.admins
}

data "github_team" "teams" {
  count = length(var.teamSlugs)
  slug  = var.teamSlugs[count.index]
}

resource "github_branch_protection" "protect_main" {
  repository_id                   = github_repository.project.node_id
  pattern                         = var.defaultBranchName
  enforce_admins                  = var.enforceAdmins
  require_signed_commits          = false
  required_linear_history         = true
  require_conversation_resolution = true
  allows_deletions                = false
  allows_force_pushes             = var.allowForcePushToMain
  push_restrictions               = concat(data.github_users.admins.node_ids, var.allowPushToMainFromNodeIds, data.github_team.teams[*].node_id)

  required_status_checks {
    strict   = var.requireStrictStatusChecks
    contexts = var.requiredStatusChecksContextsMain
  }

  required_pull_request_reviews {
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    dismissal_restrictions          = data.github_users.admins.node_ids
    required_approving_review_count = 1
    pull_request_bypassers          = data.github_users.admins.node_ids
    require_last_push_approval      = var.prRequireLastApproval
  }

}

resource "github_branch_protection" "protect_develop" {
  count                           = length(var.developBranchName) > 0 ? 1 : 0
  repository_id                   = github_repository.project.node_id
  pattern                         = var.developBranchName
  enforce_admins                  = var.enforceAdmins
  require_signed_commits          = false
  required_linear_history         = true
  require_conversation_resolution = true
  allows_deletions                = false
  allows_force_pushes             = false
  push_restrictions               = concat(data.github_users.admins.node_ids, var.allowPushToMainFromNodeIds, data.github_team.teams[*].node_id)

  required_status_checks {
    strict   = var.requireStrictStatusChecks
    contexts = var.requiredStatusChecksContextsMain
  }

  required_pull_request_reviews {
    require_code_owner_reviews      = true
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    dismissal_restrictions          = data.github_users.admins.node_ids
    required_approving_review_count = 1
    pull_request_bypassers          = data.github_users.admins.node_ids
    require_last_push_approval      = var.prRequireLastApproval
  }
}
