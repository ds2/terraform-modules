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
