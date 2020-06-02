variable "clusterName" {
  type = string
}

variable "subnetIds" {
  type = set(string)
}

variable "clusterSize" {
  type    = number
  default = 1
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

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "instanceType" {
  type    = set(string)
  default = ["t3.medium"]
}

variable "vpcId" {
  type = string
}
