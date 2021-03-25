output "arn" {
  value = aws_eks_cluster.cluster.arn
}

output "id" {
  value = aws_eks_cluster.cluster.id
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cacert" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "name" {
  value = aws_eks_cluster.cluster.name
}
