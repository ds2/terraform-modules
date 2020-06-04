variable "owners" {
  type    = set(string)
  default = ["amazon", "self"]
}

variable "imgNames" {
  type    = set(string)
  default = ["amzn2-ami-hvm*"]
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

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "subnetId" {
  type = string
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}
