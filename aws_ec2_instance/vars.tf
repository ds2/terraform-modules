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
  default = [80, 443]
}

variable "volumeSize" {
  type    = number
  default = null
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "subnetGrpId" {
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
