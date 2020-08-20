resource "github_repository" "project" {
  name                   = var.name
  description            = var.description
  homepage_url           = var.homepage
  private                = var.isPrivate
  has_projects           = var.hasProjects
  has_issues             = var.hasIssues
  has_wiki               = var.hasWiki
  has_downloads          = var.hasDownloads
  default_branch         = var.defaultBranch
  delete_branch_on_merge = true
  topics                 = var.topics
  auto_init              = var.initialize
  allow_rebase_merge     = true
  allow_squash_merge     = false
  allow_merge_commit     = true
  is_template            = false
  license_template       = var.projectLicenseId
  gitignore_template     = var.gitignoreTemplateId
  archived               = false
}

resource "github_repository_collaborator" "admins" {
  for_each   = var.admins
  repository = github_repository.project.name
  username   = each.key
  permission = "admin"
}

resource "github_team_repository" "teams" {
  for_each   = var.teamIds
  team_id    = each.key
  repository = github_repository.project.name
  permission = "push"
}

resource "github_branch" "branch_develop" {
  repository = github_repository.project.name
  branch     = "develop"
}

# resource "github_branch" "branch_master" {
#   repository = github_repository.project.name
#   branch     = "master"
# }


resource "github_branch_protection" "protect_master" {
  repository             = github_repository.project.name
  branch                 = var.defaultBranch
  enforce_admins         = var.masterProtection.enforceAdmins
  require_signed_commits = var.masterProtection.signed

  required_status_checks {
    strict   = var.masterProtection.ciSuccessful
    contexts = var.masterProtection.statusCheckContexts
  }

  required_pull_request_reviews {
    require_code_owner_reviews      = var.masterProtection.prCodeOwnerReview
    required_approving_review_count = var.masterProtection.prApprovalCount
    dismiss_stale_reviews           = true
    dismissal_users                 = var.masterProtection.prDismissFromUsers
    dismissal_teams                 = var.masterProtection.prDismissFromTeamSlugs
  }

  restrictions {
    users = var.masterProtection.restrictToUsers
    teams = var.masterProtection.restrictToTeamSlugs
    apps  = var.masterProtection.restrictToApps
  }
  # depends_on = [github_branch.branch_master]

}

resource "github_branch_protection" "protect_develop" {
  repository             = github_repository.project.name
  branch                 = "develop"
  enforce_admins         = var.developProtection.enforceAdmins
  require_signed_commits = var.developProtection.signed

  required_status_checks {
    strict   = var.developProtection.ciSuccessful
    contexts = var.developProtection.statusCheckContexts
  }

  required_pull_request_reviews {
    require_code_owner_reviews      = var.developProtection.prCodeOwnerReview
    required_approving_review_count = var.developProtection.prApprovalCount
    dismiss_stale_reviews           = true
    dismissal_users                 = var.developProtection.prDismissFromUsers
    dismissal_teams                 = var.developProtection.prDismissFromTeamSlugs
  }

  restrictions {
    users = var.developProtection.restrictToUsers
    teams = var.developProtection.restrictToTeamSlugs
    apps  = var.developProtection.restrictToApps
  }
  depends_on = [github_branch.branch_develop]
}
