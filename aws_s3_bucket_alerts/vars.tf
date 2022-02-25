variable "s3BucketName" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "sizeThreshold" {
  type    = number
  default = 10000
}
variable "objectCountThreshold" {
  type    = number
  default = 1000
}

variable "period" {
  type    = number
  default = 120
}

variable "snsAlarmArns" {
  type    = set(string)
  default = []
}

variable "snsOkArns" {
  type    = set(string)
  default = []
}
variable "snsNoDataArns" {
  type    = set(string)
  default = []
}
