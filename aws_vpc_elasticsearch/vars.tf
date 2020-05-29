variable "name" {
  type = string
}

variable "esVersion" {
  type    = string
  default = "7.4"
}

variable "vpcId" {
  type = string
}

variable "volumeSize" {
  type    = number
  default = 10
}

variable "kmsKeyArn" {
  type    = string
  default = null
}

variable "instanceType" {
  type    = string
  default = "r5.large.elasticsearch"
}
variable "masterInstanceType" {
  type    = string
  default = "r5.large.elasticsearch"
}

variable "instanceCount" {
  type    = number
  default = 1
}

variable "masterCount" {
  type    = number
  default = 0
}

variable "subnetGrpIds" {
  type = set(string)
}

variable "logTypes" {
  type    = set(string)
  default = ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS"]
}

variable "snapshotStartHourUtc" {
  type    = number
  default = 23
}
