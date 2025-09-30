data "gitlab_group" "group" {
  group_id = var.groupId
}

resource "gitlab_group_label" "fixme" {
  group       = data.gitlab_group.group.id
  name        = "fixme"
  color       = "#ffaa00"
  description = "A bug that needs to be fixed (in a future release)"
}

resource "gitlab_group_label" "prio1" {
  group       = data.gitlab_group.group.id
  name        = "priority::critical"
  color       = "#ff0000"
  description = "A bug that needs to be fixed (in a future release)"
}
resource "gitlab_group_label" "prio2" {
  group       = data.gitlab_group.group.id
  name        = "priority::top"
  color       = "#ff8800"
  description = "A bug that should to be fixed (in a future release)"
}
