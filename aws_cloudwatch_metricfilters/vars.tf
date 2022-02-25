variable "logGroupName" {
  type = string
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

variable "enabled" {
  type    = bool
  default = true
}

variable "loginThreshold" {
  type    = number
  default = 2
}
