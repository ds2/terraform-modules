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
  default = true
}

variable "zipFile" {
  type = string
}

variable "runtime" {
  type    = string
  default = "nodejs12.x"
}

variable "methodPath" {
  type        = string
  description = "the path to the module. Usually FILENAME<DOT>METHODNAME, basically index.js with exports.handler() -> index.handler"
  default     = "index.handler"
}

variable "kmsKeyArn" {
  type        = string
  description = "(optional) the KMS Key ARN"
  default     = null
}

variable "retentionDays" {
  type    = number
  default = 14
}

variable "environment" {
  type    = map(any)
  default = {}
}
