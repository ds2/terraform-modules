variable "name" {
  type = string
}
variable "displayName" {
  type    = string
  default = null
}

variable "kmsKeyArn" {
  type    = string
  default = "aws/sns"
}
