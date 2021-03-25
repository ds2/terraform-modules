variable "name" {
  type = string
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "creditBalanceThreshold" {
  type    = number
  default = 100
}

variable "creditUsageThreshold" {
  type    = number
  default = 2
}

variable "cpuUsageThreshold" {
  type    = number
  default = 80
}

variable "dimensions" {
  type = map(string)
}

variable "availActionArns" {
  type    = set(string)
  default = null
}

variable "availCheckPeriod" {
  type    = number
  default = 120
}

variable "availCheckCount" {
  type    = number
  default = 2
}

variable "rebootIfNotAvail" {
  type    = bool
  default = true
}
