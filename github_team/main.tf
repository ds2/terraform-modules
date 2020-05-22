resource "github_team" "team" {
  name           = var.name
  description    = var.description
  privacy        = var.isSecret ? "secret" : "closed"
  parent_team_id = var.parentTeamId
}

resource "github_team_membership" "members" {
  for_each = var.members
  team_id  = github_team.team.id
  username = each.key
  role     = "member"
}

resource "github_team_membership" "maintainers" {
  for_each = var.maintainers
  team_id  = github_team.team.id
  username = each.key
  role     = "maintainer"
}
