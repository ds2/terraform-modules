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
  type        = set(string)
  description = "The subnet group id to use. If zoneAware is set to true, then two subnets must be given from different zones!"
}

variable "zoneAware" {
  type    = bool
  default = false
}

variable "accessSubnetGrpIds" {
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

variable "adminArns" {
  type    = set(string)
  default = []
}

variable "writeArns" {
  type    = set(string)
  default = []
}

variable "readArns" {
  type    = set(string)
  default = []
}

variable "roleSuffix" {
  type    = string
  default = null
}

variable "storageBytesThreshold" {
  type    = number
  default = 435000000
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "missingData" {
  type    = string
  default = "missing"
}
