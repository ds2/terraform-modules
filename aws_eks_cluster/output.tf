output "arn" {
  value = aws_eks_cluster.cluster.arn
}

output "id" {
  value = aws_eks_cluster.cluster.id
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}
