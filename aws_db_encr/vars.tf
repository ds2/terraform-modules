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
  type = string
}

variable "subnetGrpIds" {
  type = list(string)
}

variable "kmsKeyArn" {
  type        = string
  description = "the arn of the symmetric key"
  default     = null
}

variable "multiAZ" {
  type    = bool
  default = false
}

variable "storageScaler" {
  type    = number
  default = null
}

variable "vpcId" {
  type = string
}

variable "dbVersion" {
  type    = string
  default = "12.2"
}

variable "dbName" {
  type = string
}

variable "backupRetentionDays" {
  type    = number
  default = 30
}
