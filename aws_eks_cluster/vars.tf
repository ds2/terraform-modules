variable "clusterName" {
  type = string
}

variable "subnetIds" {
  type = set(string)
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "clusterSize" {
  type    = number
  default = 0
}
variable "clusterMaxSize" {
  type    = number
  default = 10
}

variable "k8sVersion" {
  type    = string
  default = "1.16"
}

variable "sshKeyName" {
  type = string
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "asgName" {
  type    = string
  default = null
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}

variable "logTypes" {
  type    = set(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "instanceType" {
  type    = set(string)
  default = ["t3a.medium"]
}

variable "vpcId" {
  type = string
}

variable "creditBalanceThreshold" {
  type    = number
  default = 10
}

variable "logRetentionDays" {
  type    = number
  default = 365
}
