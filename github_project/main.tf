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

# resource "github_branch_protection" "protect_master" {
#   repository     = github_repository.project.name
#   branch         = "master"
#   enforce_admins = true

#   required_status_checks {
#     strict   = false
#     contexts = ["ci/travis"]
#   }

#   required_pull_request_reviews {
#     dismiss_stale_reviews = true
#     dismissal_users       = ["foo-user"]
#     dismissal_teams       = ["${github_team.example.slug}", "${github_team.second.slug}"]
#   }

#   restrictions {
#     users = ["foo-user"]
#     teams = ["${github_team.example.slug}"]
#     apps  = ["foo-app"]
#   }
# }