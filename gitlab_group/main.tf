/*
* # gitlab_group
*
* to create a group within Gitlab.
*
* Be aware that on GitLab SaaS (aka gitlab.com), you must use the GitLab UI to create groups without a parent group. You cannot use the API to do this.
*/
resource "gitlab_group" "grp" {
  name                              = var.name
  path                              = var.path
  description                       = var.description
  visibility_level                  = var.visibility
  parent_id                         = var.parent_group_id
  auto_devops_enabled               = var.autoDevOps
  emails_enabled                    = var.allowEmails
  lfs_enabled                       = true
  prevent_forking_outside_group     = var.preventOutsideGrpForking
  require_two_factor_authentication = var.require2FA
  default_branch_protection_defaults {
    allow_force_push           = false
    developer_can_initial_push = false
  }

  lifecycle {
    ignore_changes = [prevent_forking_outside_group]
  }
}
