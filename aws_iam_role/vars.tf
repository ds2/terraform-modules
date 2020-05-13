variable "roleName" {
  type = string
}

variable "policyData" {
  type = string
}

variable "assumeRolePolicy" {
  type    = string
  default = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": "rolePolicy1"
        }
      ]
    }
EOF
}
