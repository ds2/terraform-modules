variable "name" {
  type    = string
  default = null
}

variable "prefix" {
  type    = string
  default = null
}

variable "retentionDays" {
  type    = number
  default = 90
}

variable "kmsKeyArn" {
  type = string
}
