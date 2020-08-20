variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "my test function"
}

variable "t0" {
  type    = number
  default = 3
}

variable "publish" {
  type    = bool
  default = false
}

variable "file" {
  type = string
}

variable "runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "handler" {
  type    = string
  default = "exports.test"
}

variable "kmsKeyArn" {
  type        = string
  description = "(optional) the KMS Key ARN"
}

variable "retentionDays" {
  type    = number
  default = 14
}
