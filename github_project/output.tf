output "full_name" {
  value = github_repository.project.full_name
}

output "ssh_clone_url" {
  value = github_repository.project.ssh_clone_url
}

output "git_clone_url" {
  value = github_repository.project.git_clone_url
}

output "http_clone_url" {
  value = github_repository.project.http_clone_url
}

output "http_url" {
  value = github_repository.project.http_url
}
