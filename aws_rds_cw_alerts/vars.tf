variable "dbInstanceId" {
  type = string
}

variable "monitorCreditBalance" {
  type    = bool
  default = false
}

variable "cpuUtilThreshold" {
  type    = number
  default = 80
}

variable "storageBytesThreshold" {
  type    = number
  default = 1073741824 # 1GB
}

variable "alarmSnsArns" {
  type    = set(string)
  default = []
}
variable "okSnsArns" {
  type    = set(string)
  default = []
}
variable "insufficientSnsArns" {
  type    = set(string)
  default = []
}
variable "highConnectionThreshold" {
  type    = number
  default = 50
}

variable "missingData" {
  type    = string
  default = "missing"
}
