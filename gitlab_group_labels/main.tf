data "gitlab_group" "group" {

}

resource "gitlab_group_label" "fixme" {
  name = "fixme"
  color = "#ffaa00"
  description = "A bug that needs to be fixed (in a future release)"
}

resource "gitlab_group_label" "prio1" {
  name = "priority::critical"
  color = "#ff0000"
  description = "A bug that needs to be fixed (in a future release)"
}
resource "gitlab_group_label" "prio2" {
  name = "priority::top"
  color = "#ff8800"
  description = "A bug that needs to be fixed (in a future release)"
}
