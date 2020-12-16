resource "bitbucket_project" "project" {
  owner       = var.workspaceId
  name        = var.name
  key         = var.id
  description = var.descr
  is_private  = var.isPrivate
}
