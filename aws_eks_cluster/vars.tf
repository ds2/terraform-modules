variable "clusterName" {
  type = string
}

variable "subnetIds" {
  type = list(string)
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "clusterSize" {
  type    = number
  default = 1
}
variable "clusterMaxSize" {
  type    = number
  default = 1
}

variable "k8sVersion" {
  type    = string
  default = "1.15"
}

variable "sshKeyName" {
  type = string
}
