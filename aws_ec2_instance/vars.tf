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
