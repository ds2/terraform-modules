variable "amiId" {
  type = string
}

variable "instanceType" {
  type    = string
  default = "t3a.nano"
}

variable "name" {
  type = string
}

variable "sshKeyName" {
  type = string
}

variable "allowedExternalTcpPorts" {
  type    = set(number)
  default = []
}

variable "allowedVpcTcpPorts" {
  type    = set(number)
  default = [22]
}

variable "allowedExternalUdpPorts" {
  type    = set(number)
  default = []
}

variable "volumeSize" {
  type    = number
  default = null
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "subnetId" {
  type = string
}

variable "isPublic" {
  type    = bool
  default = false
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "availActionArns" {
  type    = set(string)
  default = null
}

variable "securityGroupIds" {
  type    = set(string)
  default = []
}

variable "dnsDomain" {
  type    = string
  default = null
}

variable "dnsName" {
  type    = string
  default = null
}

variable "dnsInternalNamePostfix" {
  type    = string
  default = "-internal"
}

variable "unlimitedCpuCredits" {
  type    = bool
  default = null
}

variable "allowUnsecureEgress" {
  type    = bool
  default = false
}

variable "allowedEgressTcpPorts" {
  type    = set(number)
  default = [80, 443]
}

variable "allowedEgressUdpPorts" {
  type    = set(number)
  default = [123]
}

variable "swapSize" {
  type    = number
  default = 0
}

variable "swapDevName" {
  type    = string
  default = "/dev/xvdf"
}

variable "availCheckPeriod" {
  type    = number
  default = 60
}

variable "availCheckCount" {
  type    = number
  default = 3
}

variable "creditBalanceThreshold" {
  type    = number
  default = 100
}

variable "creditUsageThreshold" {
  type    = number
  default = 2
}