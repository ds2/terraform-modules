resource "bitbucket_repository" "repo" {
  owner             = var.owner
  name              = var.repoName
  slug              = var.repoId
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


resource "bitbucket_branch_restriction" "repo_master" {
  count      = var.reviewers != null ? 1 : 0
  owner      = var.owner
  repository = bitbucket_repository.repo.slug

  kind    = "push"
  pattern = "master"
  users   = var.reviewers
}

resource "bitbucket_branch_restriction" "repo_develop" {
  count      = var.reviewers != null ? 1 : 0
  owner      = var.owner
  repository = bitbucket_repository.repo.slug

  kind    = "push"
  pattern = "develop"
  users   = var.reviewers
}

resource "bitbucket_default_reviewers" "coreReviewers" {
  count      = var.reviewers != null ? 1 : 0
  owner      = var.owner
  repository = bitbucket_repository.repo.slug

  reviewers = var.reviewers
}
