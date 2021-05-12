output "a" {
  value = <<EOF
role=${module.role_test.arn}
EOF
}

# output "awsEks" {
#   value = module.aws_eks_test.kubeConfigCmd
# }
