resource "github_branch_protection" "bp" {
  count                           = var.enabled ? 1 : 0
  repository_id                   = var.repository_node_id
  pattern                         = var.pattern
  enforce_admins                  = var.enforceAdmins
  require_signed_commits          = false
  required_linear_history         = true
  require_conversation_resolution = true
  allows_deletions                = false
  allows_force_pushes             = var.allowForcePush
  push_restrictions               = var.push_node_ids

  required_status_checks {
    strict   = var.requireStrictStatusChecks
    contexts = var.status_checks_contexts
  }

  required_pull_request_reviews {
    require_code_owner_reviews      = var.require_code_owner_reviews
    dismiss_stale_reviews           = true
    restrict_dismissals             = var.restrict_dismissals
    dismissal_restrictions          = var.dismissal_node_ids
    required_approving_review_count = var.required_approving_review_count
    pull_request_bypassers          = var.prBypasserNodeIds
    require_last_push_approval      = var.require_last_push_approval
  }

}
