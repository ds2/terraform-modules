variable "name" {
  type = string
}

variable "dbPort" {
  type    = number
  default = 5432
}

variable "instanceClass" {
  type    = string
  default = "db.t3.micro"
}

variable "storageSize" {
  type    = number
  default = 5
}

variable "dbAdminUser" {
  type = string
}

variable "dbAdminPw" {
  type      = string
  sensitive = true
}

variable "subnetGrpIds" {
  type = set(string)
}

variable "accessSubnetGrpIds" {
  type = set(string)
}

variable "kmsKeyArn" {
  type        = string
  description = "the arn of the symmetric key"
  default     = null
}

variable "multiAZ" {
  type    = bool
  default = true
}

variable "maxStorage" {
  type    = number
  default = null
}

variable "vpcId" {
  type = string
}

variable "dbVersion" {
  type    = string
  default = "13.1"
}

variable "dbName" {
  type = string
}

variable "backupRetentionDays" {
  type    = number
  default = 30
}

variable "paramsApplied" {
  type    = string
  default = null
}

variable "paramFamily" {
  type    = string
  default = "postgres12"
}

variable "dbParams" {
  type    = map(any)
  default = {}
}

variable "snsTopicArns" {
  type    = set(string)
  default = null
}

variable "highConnectionThreshold" {
  type    = number
  default = 40
}

variable "storageBytesThreshold" {
  type    = number
  default = 435000000
}

variable "cpuUtilThreshold" {
  type    = number
  default = 90
}

variable "monitorCreditBalance" {
  type    = bool
  default = true
}

variable "logfileRetentionDays" {
  type    = number
  default = 365
}

variable "allowMajorUpgrade" {
  type    = bool
  default = false
}
