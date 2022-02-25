variable "username" {
  type = string
}

variable "policyArns" {
  type    = list(string)
  default = []
}

variable "awsPath" {
  type    = string
  default = "/"
}
