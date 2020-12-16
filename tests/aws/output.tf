output "a" {
  value = <<EOF
role=${module.role_test.arn}
EOF
}