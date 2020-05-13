output "a" {
    value=<<EOF
role=${module.role_test.arn}
user=${module.user1.arn}
user_key=${module.user1.accesskey}
user_skey=${module.user1.secretkey}
EOF
}