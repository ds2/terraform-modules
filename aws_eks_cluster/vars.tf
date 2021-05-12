variable "clusterName" {
  type = string
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "k8sVersion" {
  type    = string
  default = "1.19"
}

variable "asgName" {
  type    = string
  default = null
}

variable "logTypes" {
  type    = set(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "logRetentionDays" {
  type    = number
  default = 365
}

variable "subnetIds" {
  type = set(string)
}

variable "k8sSvcCidr" {
  type    = string
  default = "172.20.0.0/16"
}
