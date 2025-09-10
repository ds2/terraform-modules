output "id" {
  value       = gitlab_group.grp.id
  description = "the id of the group"
}

output "web_url" {
  value = gitlab_group.grp.web_url
}
