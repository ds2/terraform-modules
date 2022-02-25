variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
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

variable "useNameNotPrefix" {
  type    = bool
  default = false
}

variable "rolePath" {
  type    = string
  default = null
}

variable "maxSessionSeconds" {
  type    = number
  default = null
}

variable "policyArns" {
  type    = list(string)
  default = []
}

variable "policyData" {
  type    = string
  default = null
}
