resource "bitbucket_repository" "repo" {
  owner             = var.ownerName
  name              = var.name
  slug              = var.id
  description       = var.descr
  is_private        = var.isPrivate
  language          = var.language
  has_issues        = var.hasIssues
  has_wiki          = var.hasWiki
  pipelines_enabled = var.hasPipelines
  fork_policy       = var.forkPolicy
  project_key       = var.projectId
  scm               = "git"
  lifecycle {
    ignore_changes = [project_key]
  }
}


resource "bitbucket_branch_restriction" "br_main" {
  count      = var.reviewers != null ? 1 : 0
  owner      = bitbucket_repository.repo.owner
  repository = bitbucket_repository.repo.slug

  kind    = "push"
  pattern = var.mainBranchName
  users   = var.reviewers
}

resource "bitbucket_branch_restriction" "br_develop" {
  count      = var.reviewers != null ? 1 : 0
  owner      = bitbucket_repository.repo.owner
  repository = bitbucket_repository.repo.slug

  kind    = "push"
  pattern = "develop"
  users   = var.reviewers
}

resource "bitbucket_default_reviewers" "reviewers" {
  count      = var.reviewers != null ? 1 : 0
  owner      = bitbucket_repository.repo.owner
  repository = bitbucket_repository.repo.slug
  reviewers  = var.reviewers
  lifecycle {
    ignore_changes = [reviewers]
  }
}
