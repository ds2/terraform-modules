output "id" {
  value = gitlab_project.project.id
}

output "sshUrl" {
  value = gitlab_project.project.ssh_url_to_repo
}

output "httpUrl" {
  value = gitlab_project.project.http_url_to_repo
}

output "webUrl" {
  value = gitlab_project.project.web_url
}
